require 'spec_helper'

describe Bullhorn::Client, :remote! => true do

  before(:each) do
    username = ENV['bullhorn_username']
    password = ENV['bullhorn_password']
    api_key = ENV['bullhorn_api_key']
    @client = Bullhorn::Client.new(username, password, api_key)
  end

  it "can be start a session" do
    session = @client.start_session
    session[:session].should_not be_nil
    session[:corporation_id].should_not be_nil
    session[:user_id].should_not be_nil
  end

  context 'with a session' do
    before(:each) do
      session = @client.start_session
      @session = session[:session]
      @corporation_id = session[:corporation_id]
      @user_id = session[:user_id]
    end

    context 'Candidate Processing' do

      it "can save a candidate" do
        candidate = Bullhorn::Candidate.new
        candidate[:external_id] = 'ExternalID1'
        candidate[:first_name] = 'John'
        candidate[:last_name] = 'Doeza'
        candidate[:email] = 'dennis+johndoeza@example.com'
        candidate[:will_relocate] = true
        candidate[:veteran] = 'Y'
        candidate[:salary_low] = '50000'

        saved_candidate = @client.save_candidate(candidate)
        saved_candidate.should_not be_nil
        saved_candidate[:external_id].should eq('ExternalID1')
        saved_candidate[:first_name].should eq('John')
        saved_candidate[:last_name].should eq('Doeza')
        saved_candidate[:email].should eq('dennis+johndoeza@example.com')
        saved_candidate[:will_relocate].should eq(true)
        saved_candidate[:veteran].should eq('Y')
        saved_candidate[:salary_low].should eq('50000')
        saved_candidate[:user_id].should_not be_nil
      end

      context "with a saved candidate" do
        before(:each) do
          @first_name = 'Jane'
          @last_name = 'Doe'
          @email = 'dennis+janedoe@example.com'
          candidate = Bullhorn::Candidate.new
          candidate[:external_id] = 'ExternalID2'
          candidate[:first_name] = @first_name
          candidate[:last_name] = @last_name
          candidate[:email] = @email
          saved_candidate = @client.save_candidate(candidate)
          @candidate_id = saved_candidate[:user_id]
        end

        it "can query a candidate by email" do
          candidate_id = @client.query_candidate_by_email('dennis@example.com')
          candidate_id.should_not be_nil
          candidate_id.should eq(@candidate_id)
        end

        it "can find a candidate by id" do
          candidate = @client.find_candidate_by_id(@candidate_id)
          candidate.should_not be_nil
          candidate[:first_name].should eq(@first_name)
          candidate[:last_name].should eq(@last_name)
          candidate[:email].should eq(@email)
        end

        it "can add a candidate file" do
          file_id = nil
          filename = File.dirname(__FILE__) + "/sample_resumes/resume.doc"
          File.open(filename, "r") do |file|
            contents = file.read
            file_id = @client.add_candidate_file(5, 'test_resume.doc', contents)
          end
          file_id.should_not be_nil
        end

        context "with an added file" do
          before(:each) do
            @file_id = nil
            filename = File.dirname(__FILE__) + "/sample_resumes/resume.doc"
            File.open(filename, "r") do |file|
              contents = file.read
              @file_id = @client.add_candidate_file(5, 'test_resume.doc', contents)
            end
          end

          it "can get a list of candidate files by id" do
            files_array = @client.get_candidate_files(@candidate_id)
            files_array.should_not be_nil
            files_array.size.should eq(1)
            files_array[0][:id].should eq(@file_id)
            files_array[0][:type].should eq('Resume')
          end

          it "can get a candidate file by id" do
            file_data = @client.get_candidate_file(@candidate_id, @file_id)
            file_data.should_not be_nil
          end

          it "can update a candidate file" do
            response = nil
            filename = File.dirname(__FILE__) + "/sample_resumes/resume.doc"
            File.open(filename, "r") do |file|
              contents = file.read
              response = @client.update_candidate_file(@candidate_id, @file_id, 'test_resume.doc', contents)
            end
            response.should_not be_nil
          end

          it "can delete a candidate file" do
            response = @client.delete_candidate_file(@candidate_id, @file_id)
            response.should_not be_nil
          end

        end
      end
    end

    context 'ClientCorporation Processing' do

      it "can save a ClientCorporation" do
        company = Bullhorn::ClientCorporation.new
        company[:external_id] = 'TestCompanyID'
        company[:name] = 'Test Company'

        saved_company = @client.save_client_corporation(company)
        saved_company.should_not be_nil
        saved_company[:external_id].should eq('TestCompanyID')
        saved_company[:name].should eq('Test Company')
        saved_company[:client_corporation_id].should_not be_nil
      end

      context "with a saved ClientCorporation" do
        before(:each) do
          @external_id = 'TestCompanyID2'
          company = Bullhorn::ClientCorporation.new
          company[:external_id] = 'TestCompanyID2'
          company[:name] = 'Test Company 2'
          saved_company = @client.save_client_corporation(company)
          @client_corporation_id = saved_company[:client_corporation_id]
        end

        it "can query a ClientCorporation by external_id" do
          company_id = @client.query_client_corporation_by_external_id(@external_id)
          company_id.should_not be_nil
          company_id.should eq(@client_corporation_id)
        end

        it "can find a ClientCorporation by id" do
          company = @client.find_client_corporation_by_id(@client_corporation_id)
          company.should_not be_nil
          company[:external_id].should eq(@external_id)
        end

      end
    end

    context 'ClientContact Processing' do

      it "can save a ClientContact" do
        contact = Bullhorn::ClientContact.new
        contact[:email] = 'dennis+client@example.com'
        contact[:external_id] = 'ExternalID'
        contact[:first_name] = 'Bob'
        contact[:last_name] = 'Doe'
        contact[:client_corporation_id] = 1

        saved_contact = @client.save_client_contact(contact)
        saved_contact.should_not be_nil
        saved_contact[:user_id].should_not be_nil
        saved_contact[:email].should eq('dennis+client@example.com')
        saved_contact[:external_id].should eq('ExternalID1')
      end

      context "with a saved ClientContact" do
        before(:each) do
          @email = 'dennis+clientX@example.com'
          contact = Bullhorn::ClientContact.new
          contact[:email] = @email
          contact[:external_id] = 'ExternalIDX'
          contact[:first_name] = 'Bob'
          contact[:last_name] = 'Doe-A'
          contact[:client_corporation_id] = 1
          saved_contact = @client.save_client_contact(contact)
          @client_contact_id = saved_contact[:user_id]
        end

        it "can query a ClientContact by email" do
          contact_id = @client.query_client_contact_by_email(@email)
          contact_id.should_not be_nil
          contact_id.should eq(@client_contact_id)
        end

        it "can find a ClientContact by id" do
          contact = @client.find_client_contact_by_id(@client_contact_id)
          contact.should_not be_nil
          contact[:email].should eq(@email)
        end

      end
    end

    context 'JobOrder Processing' do

      it "can save a JobOrder" do
        job = Bullhorn::JobOrder.new
        job[:external_id] = 'Job ID'
        job[:client_corporation_id] = 1
        job[:client_contact_id] = 1
        job[:title] = 'Test Job Posting'
        job[:description] = 'Just a test'
        job[:salary] = '50000'
        job[:salary_unit] = 'yearly'
        job[:start_date] = DateTime.now
        
        saved_job = @client.save_job_order(job)
        saved_job.should_not be_nil
        saved_job[:job_order_id].should_not be_nil
        saved_job[:client_corporation_id].should eq(1)
        saved_job[:client_contact_id].should eq(1)
        saved_job[:title].should eq('Test Job Posting')
        saved_job[:description].should eq('Just a test')
        saved_job[:salary].should eq('50000')
        saved_job[:salary_unit].should eq('yearly')
      end

      context "with a saved JobOrder" do
        before(:each) do
          @external_id = 'JobID3'
          job = Bullhorn::JobOrder.new
          job[:external_id] = @external_id
          job[:client_corporation_id] = 1
          job[:client_contact_id] = 1
          job[:title] = 'Test Job Posting 3'
          job[:description] = 'Just a test 3'
          job[:salary] = '50000'
          job[:salary_unit] = 'yearly'
          job[:start_date] = DateTime.now
          saved_job = @client.save_job_order(job)
          @job_id = saved_job[:job_order_id]
        end

        it "can query a JobOrder by external_id" do
          job_id = @client.query_job_order_by_external_id(@external_id)
          job_id.should_not be_nil
          job_id.should eq(@job_id)
        end

        it "can find a ClientContact by id" do
          job = @client.find_job_order_by_id(@job_id)
          job.should_not be_nil
          job[:external_id].should eq(@external_id)
        end

      end
    end

    context 'Resume Parsing' do
      it "can parse a doc resume" do
        response = nil
        filename = File.dirname(__FILE__) + "/sample_resumes/resume.doc"
        File.open(filename, "r") do |file|
          contents = file.read
          response = @client.parse_resume(contents)
        end
        response[:success].should_not be_nil
        response[:success].should eq(true)
        response[:hr_xml].should_not be_nil
      end

      it "can parse a pdf resume" do
        response = nil
        filename = File.dirname(__FILE__) + "/sample_resumes/resume.pdf"
        File.open(filename, "r") do |file|
          contents = file.read
          response = @client.parse_resume(contents)
        end
        response[:success].should_not be_nil
        response[:success].should eq(true)
        response[:hr_xml].should_not be_nil
      end
    end

  end

end
