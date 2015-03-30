module API
  module V1
    class Base < Grape::API
      rescue_from :all do |e|

        Rails.logger.error "API ERROR #{e.to_s}"

        case e.http_code
        when 400...499, 503, 504

          json = JSON.parse e.response

          json["error"] = json["code"]

          ErrorLog.create({
            :api_key => @api_key,
            :raw => e.inspect,
            :stacktrace => e.backtrace.join("\n"),
            :error => json["error"],
            :message => json["message"],
            :major_code => json["statusCode"],
            :minor_code => json["minorCode"]
          })

          Rails.logger.error "#{e.http_code} #{json["minorCode"]} '#{json["message"]}'"

          Rack::Response.new(ActiveSupport::JSON.encode(json), e.http_code, { 'Content-type' => 'application/json' }).finish

        else
          # Log it
          Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"

          # Notify external service of the error
          Airbrake.notify(e)

          # Send error and backtrace down to the client in the response body (only for internal/testing purposes of course)
          Rack::Response.new({ message: e.message, backtrace: e.backtrace }, e.http_code, { 'Content-type' => 'application/json' }).finish
        end

      end
      helpers do
        def validate_partner

          error!('Invalid Access', 401) unless params[:partner_key]

          @api_key = ApiKey.where(:access_token => params[:partner_key]).first
          error!('Invalid Access', 401) unless @api_key

          @partner = @api_key.partner

          payload = params[:payload]
          checksum = Digest::MD5.hexdigest(payload + @api_key.salt)

          error!('Invalid Access', 401) unless params[:checksum] == checksum

          JSON.parse(params[:payload],:symbolize_names => true).map{ |key, value|
            params[key] = value
          }

          error!('Invalid Access', 401) unless params[:time_stamp]

          time_stamp = Time.parse(params[:time_stamp])

          error!('Invalid Access', 401) unless (time_stamp + 2 * 60) > Time.now

        end

        def warden
          env['warden']
        end

        def authenticated
          return true if warden.authenticated?
          params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
        end

        def current_user
          warden.user || @user
        end

      end

      mount API::V1::Customers
      mount API::V1::Transactions
      mount API::V1::FinancialInstitutions
    end
  end
end
