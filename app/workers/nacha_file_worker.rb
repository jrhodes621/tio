class NachaFileWorker

	@queue = :nacha_file_queue
	def self.perform

		# Create ACH file
		ach = ACH::ACHFile.new
		trace_number = 0

    nacha_file = Batch.create({
      :start_time => Time.now,
      :batch_status => "Processing"
    })

		partner = Partner.first
    transactions = Transaction.where(:transaction_status =>  "Pending")
    debits = transactions.where(:transaction_type => "W")
    credits = transactions.where(:transaction_type => "D")

		# File Header
		fh = ach.header
		fh.immediate_destination = partner.immediate_destination;
		fh.immediate_destination_name = partner.immediate_destination_name;
		fh.immediate_origin = partner.immediate_origin;
		fh.immediate_origin_name = partner.immediate_origin_name;

		#Batch
		batch = ACH::Batch.new
		bh = batch.header
		bh.company_name = partner.company_name
		bh.company_identification = partner.company_identification
		bh.standard_entry_class_code = "WEB"
		bh.company_entry_description = partner.company_entry_description
		bh.company_descriptive_date = Date.today
		bh.effective_entry_date = Date.today + 1
		bh.originating_dfi_identification = partner.originating_financial_institution

		ach.batches << batch

		for transaction in debits do
			# Detail Entry
			ed = ACH::EntryDetail.new
			if transaction.account_type == "S"
				ed.transaction_code = ACH::SAVING_DEBIT
			end
			if transaction.account_type == "C"
				ed.transaction_code = ACH::CHECKING_DEBIT
			end
			ed.routing_number = transaction.routing_number
			ed.account_number = transaction.account_number
			ed.amount = transaction.amount
			ed.individual_id_number = transaction.individual_name
			ed.individual_name = transaction.individual_name
			ed.originating_dfi_identification = partner.originating_financial_institution

      #transaction.trace_number = ed.trace_number
      transaction.batch = nacha_file

			batch.entries << ed
		end
		for transaction in credits do
			# Detail Entry
			ed = ACH::EntryDetail.new
			if transaction.account_type == "S"
				ed.transaction_code = ACH::SAVING_CREDIT
			end
			if transaction.account_type == "C"
				ed.transaction_code = ACH::CHECKING_CREDIT
			end
			ed.routing_number = transaction.routing_number
			ed.account_number = transaction.account_number
			ed.amount = transaction.amount
			ed.individual_id_number = transaction.individual_name
			ed.individual_name = transaction.individual_name
			ed.originating_dfi_identification = partner.originating_financial_institution

      #transaction.trace_number = ed.trace_number
      transaction.batch = nacha_file

			batch.entries << ed
		end

		# Insert trace numbers
		batch.entries.each{ |entry| entry.trace_number = (trace_number += 1) }
		#end

		output = ach.to_s
		filename = SecureRandom.uuid + ".txt"

		service = S3::Service.new(
			:access_key_id => ENV["AWS_ACCESS_KEY_ID"],
			:secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
		)

		bucket_name = "NACHAFILES_Test"
		bucket = service.buckets.find(bucket_name)

		s3_file = bucket.objects.build(filename)
		s3_file.content = output

		s3_file.save

    filename =  "https://s3.amazonaws.com/" + bucket_name + "/" + filename

    nacha_file.end_time = Time.now
    nacha_file.filename = filename
    nacha_file.batch_status = "Complete"

    nacha_file.save!

    transactions.each do |transaction|
      transaction.save!
    end

	end

end
