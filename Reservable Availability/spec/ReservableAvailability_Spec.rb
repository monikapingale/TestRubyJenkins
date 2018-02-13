#Created By : Pragalbha Mahajan
#Created Date : 28/12/2017
#Modified date :

require "selenium-webdriver"
require 'enziUIUtility'
require "rspec"
#require "metaforce"
#require_relative 'E:\Projects\Training\Contact Availability\pageObject\ReservableAvailability.rb'
require_relative 'E:\Projects\Training\Contact Availability\pageObject\ReservableAvailability.rb'

describe "Reservable Availability Tester" do
	before(:all){
		@driver = Selenium::WebDriver.for :firefox
		@objReservableAvailability = ReservableAvailability.new(@driver)
		testRecordFile = File.open("E:/Projects/Training/Contact Availability/TestData/Test_ContactRecord.json", "r")
		testRecordsInJson = testRecordFile.read()
		@testRecords = JSON.parse(testRecordsInJson)
	}

	context "Navigation to Reservable Availability Page", :contextDemo => true, :pendingDemo => true, :unitDemo => true do
		it "should go to Home page", :sanity => true do
			#puts "id=#{example.metadata[:id]}"
			if expect(@objReservableAvailability.getDriver.title).to eq "Salesforce - Unlimited Edition"
				puts "Successfully redirected to Home Page"
			end
		end

		it "should go to Reservable Availability Page", :sanity => true do
			@objReservableAvailability.redirectToAvailability()
			puts "Successfully redirected to Reservable Availability Page"
			sleep(10)
		end
	end

	context "context tagname demo", :Demo => true do
		it "demo it" do
			@objReservableAvailability.selectElement(@driver,"No",:option)
		end
	end
	
=begin
	it "should create a Account" do
		if expect(@objReservableAvailability.createAccount()).not_to be_nil
			puts "Account Successfully Created"
		end
	end

	it "should create a Contact" do
		if expect(@objReservableAvailability.createContact()).not_to be_nil
			puts "Contact Successfully Created"
		end
	end

	it "should go to Contact Details Page" do
		@objReservableAvailability.redirectToContactDetail()
		if expect(@objReservableAvailability.getDriver.title).to eq "Contact: Sharma ~ Salesforce - Unlimited Edition"
			puts "Successfully Redirected to Contact Detail Page"
		end
	end

	it "should go to Availability Page of Contact" do
		@objReservableAvailability.redirectToAvailability()
		#puts "Inside Spec: #{@objReservableAvailability.getDriver.title}"
		#expect(@objReservableAvailability.getDriver.title).to eq "Availability"
	end

=end

	context "Validate Preset View, Submit and Save Buttons", :contextDemo => false do
		#before(:example){
			#sleep(10)
			#@objReservableAvailability.resetForm("Select Preset Views", "Select City", "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
		#}

		it "C95:To check when nothing is selected, Save as preset view, Save & Submit button should be disabled.", :regression => true do
			expect(@objReservableAvailability.buttonEnabled?("btnSaveAsPresetView")).to eq false
			expect(@objReservableAvailability.buttonEnabled?("btnSave")).to eq false	
			expect(@objReservableAvailability.buttonEnabled?("btnSubmit")).to eq false
		end

		it "C46:To check when after selecting particular city, Save as preset view and Submit button should not visible.", :regression => true do
			@objReservableAvailability.resetForm("Select Preset Views", "Select City", "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
			@objReservableAvailability.setCity(@testRecords['scenario:2']['SetCity'])	
			expect(@objReservableAvailability.buttonEnabled?("btnSaveAsPresetView")).to eq false
			expect(@objReservableAvailability.buttonEnabled?("btnSave")).to eq false	
			expect(@objReservableAvailability.buttonEnabled?("btnSubmit")).to eq false
		end

		it "C45:To check when after selecting date from available from, Save as preset view and Submit button should not visible.", :regression => true do
			@objReservableAvailability.resetForm("Select Preset Views", "Select City", "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
			@objReservableAvailability.setAvailableFrom(@testRecords['scenario:3']['SetAvailableForm'][0])	#2019-02-23
			expect(@objReservableAvailability.buttonEnabled?("btnSaveAsPresetView")).to eq false
			expect(@objReservableAvailability.buttonEnabled?("btnSave")).to eq false	
			expect(@objReservableAvailability.buttonEnabled?("btnSubmit")).to eq false
		end

		#Use: This it passes the Preset View name to setPresetView function
		it "C56:To check when after selecting any preset view, save as preset view, Save & Submit button  will be enabled", :sanity => true do
			@objReservableAvailability.setPresetView(@testRecords['scenario:4']['SetPresetView'][0])	#Available 1ps in NYC
			expect(@objReservableAvailability.buttonEnabled?("btnSaveAsPresetView")).to eq true
			expect(@objReservableAvailability.buttonEnabled?("btnSave")).to eq true	
			expect(@objReservableAvailability.buttonEnabled?("btnSubmit")).to eq true
		end

		#Use: This it passes the City name to setCity function and Date to setAvailableFrom function
		it "C113:To check when after selecting date and particular city, Save as preset view and Submit button should be visible.", :sanity => true do
			@objReservableAvailability.resetForm("Select Preset Views", "Select City", "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
			@objReservableAvailability.setCity(@testRecords['scenario:2']['SetCity'])	#Paris
			@objReservableAvailability.setAvailableFrom(@testRecords['scenario:3']['SetAvailableForm'][0])	#2019-02-23
			expect(@objReservableAvailability.buttonEnabled?("btnSaveAsPresetView")).to eq true
			expect(@objReservableAvailability.buttonEnabled?("btnSave")).to eq false
			expect(@objReservableAvailability.buttonEnabled?("btnSubmit")).to eq true
		end
	end

	context 'Testing related to Creating Preset View', :contextDemo => false do
		it 'should Open and close Create Preset View Dialog', :regression => true do
		    @objReservableAvailability.closePresetViewDialog()
  		end

  		it 'should not create the view with blankName', :regression => true do
		    expect(@objReservableAvailability.createPresetView('')).to eq nil
		    @objReservableAvailability.closeSetPresetViewModal()
  		end

  		it 'C170:To check after saving as preset view it should be displayed in preset view list', :sanity => false do
			EnziUIUtility.wait(@driver,:id,"Minimum_Capacity__c",30)
			#EnziUIUtility.wait(@driver,nil,nil,20)
			@objReservableAvailability.resetForm("Select Preset Views", "Select City", "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
			@objReservableAvailability.setAvailableFrom('2018-11-22')
			@objReservableAvailability.setCity('Austin')
			@objReservableAvailability.setUnitType(["Bed","HotDesk","DedicatedDesk"])
			@objReservableAvailability.showRecords('Available')
			@objReservableAvailability.selectbuildings(@testRecords['scenario:9']["buildings"])
			expect(@objReservableAvailability.createPresetView(@testRecords['scenario:10']['CreatePresetView'][3])).to eq @testRecords['scenario:10']['CreatePresetView'][3]
		end
	end


	context "Testing Available form Elements", :contextDemo => false do

		it 'C31:To check when While selecting "available from" in reservable availability page, previous date should not be selected.', :regression => true do			
			expect(@objReservableAvailability.setAvailableFrom(@testRecords['scenario:3']['SetAvailableForm'][1])).to eq false	#2017-01-25
		end

		it 'C105:To check when after clicking on "today" in "available from", todays date should be selected.', :sanity => true do
			expect(@objReservableAvailability.clickToday()).to eq true
		end

		it 'C106:To check when after clicking on "clear" in "available from", selected date should be removed.', :sanity => true do
			expect(@objReservableAvailability.clickClear()).to eq true
		end

		it 'C36:To check when after clicking on "Close" in "available from", date calendar should be closed.', :regression => true do
			expect(@objReservableAvailability.clickClose()).to eq true
		end
	end

	context "Testing Min Max Capacity Elements", :contextDemo => false do
		before(:example){
			#sleep(5)	setTextBoxValue(element_id, val)
			@objReservableAvailability.resetForm(nil, nil, "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
		}
		it 'C107:To check when after entering minimum capacity less than maximum capacity, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Capacity__c",@testRecords['scenario:5']['SetMinCapacity'][0])	#10
			@objReservableAvailability.setTextBoxValue("Maximum_Capacity__c",@testRecords['scenario:6']['SetMaxCapacity'][1])	#20
			expect(@objReservableAvailability.checkError("Minimum_Capacity__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Capacity__c")).to eq false				
		end

		it 'C38:To check when after entering minimum capacity more then maximum capacity, "Invalid Value" as error message will be displayed.', :regression => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Capacity__c",@testRecords['scenario:5']['SetMinCapacity'][0])	#10
			@objReservableAvailability.setTextBoxValue("Maximum_Capacity__c",@testRecords['scenario:6']['SetMaxCapacity'][2])	#5
			expect(@objReservableAvailability.checkError("Minimum_Capacity__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Capacity__c")).to eq true
		end

		it 'C108:To check when after entering minimum capacity less than or equal to maximum capacity, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Capacity__c",@testRecords['scenario:5']['SetMinCapacity'][0])	#10
			@objReservableAvailability.setTextBoxValue("Maximum_Capacity__c",@testRecords['scenario:6']['SetMaxCapacity'][0])	#10
			expect(@objReservableAvailability.checkError("Minimum_Capacity__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Capacity__c")).to eq false
		end
			
		it 'C40:To check when after entering minimum capacity more then maximum capacity and again minimum capacity changed less than maximum capacity, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Capacity__c",@testRecords['scenario:5']['SetMinCapacity'][0]) #10
			@objReservableAvailability.setTextBoxValue("Maximum_Capacity__c",@testRecords['scenario:6']['SetMaxCapacity'][2])	#5
			@objReservableAvailability.setTextBoxValue("Minimum_Capacity__c",@testRecords['scenario:5']['SetMinCapacity'][7])	#4
			expect(@objReservableAvailability.checkError("Minimum_Capacity__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Capacity__c")).to eq false
			#@objReservableAvailability.checkError()
		end
	end

	context "Testing Min Max Price Range Elements", :contextDemo => false do
		before(:example){
			@objReservableAvailability.resetForm(nil, nil, "Minimum_Capacity__c", "Maximum_Capacity__c", "Minimum_Price_Range__c", "Maximum_Price_Range__c")
		}
		it 'C110:To check when after entering minimum price range less than maximum price range, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",@testRecords['scenario:7']['setMinPriceRange'][0])	#1000
			@objReservableAvailability.setTextBoxValue("Maximum_Price_Range__c",@testRecords['scenario:8']['setMaxPriceRange'][1])	#2000	
			expect(@objReservableAvailability.checkError("Minimum_Price_Range__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Price_Range__c")).to eq false
		end

		it 'C42:To check when after entering minimum price range more then maximum price range, "Invalid value" as error message should be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",@testRecords['scenario:7']['setMinPriceRange'][1])	#2000
			@objReservableAvailability.setTextBoxValue("Maximum_Price_Range__c",@testRecords['scenario:8']['setMaxPriceRange'][2])	#1500
			expect(@objReservableAvailability.checkError("Minimum_Price_Range__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Price_Range__c")).to eq true
		end

		it 'C111:To check when after entering minimum price range less than or equal to maximum price range, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",@testRecords['scenario:7']['setMinPriceRange'][1])	#2000
			@objReservableAvailability.setTextBoxValue("Maximum_Price_Range__c",@testRecords['scenario:8']['setMaxPriceRange'][2])	#2000
			expect(@objReservableAvailability.checkError("Minimum_Price_Range__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Price_Range__c")).to eq false
		end

		it 'C112:To check when after entering minimum price range more than maximum price range and again minimum price range changed less than maximum price range, error message should not be displayed.', :sanity => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",@testRecords['scenario:7']['setMinPriceRange'][1])	#2000
			@objReservableAvailability.setTextBoxValue("Maximum_Price_Range__c",@testRecords['scenario:8']['setMaxPriceRange'][2])	#1500
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",@testRecords['scenario:7']['setMinPriceRange'][0])	#1000
			expect(@objReservableAvailability.checkError("Minimum_Price_Range__c")).to eq false
			expect(@objReservableAvailability.checkError("Maximum_Price_Range__c")).to eq false
		end

		#10	20	21	Demo
		it 'C:To check when after entering minimum price range less than maximum price range and again minimum price range changed greater than maximum price range, error message should be displayed.', :regression => true do
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",10)	#2000
			@objReservableAvailability.setTextBoxValue("Maximum_Price_Range__c",20)	#1500
			@objReservableAvailability.setTextBoxValue("Minimum_Price_Range__c",21)	#1000
			expect(@objReservableAvailability.checkError("Minimum_Price_Range__c")).to eq true
			expect(@objReservableAvailability.checkError("Maximum_Price_Range__c")).to eq false
		end
	end

	context "Testing Unit Type Elements", :unitDemo => true do
=begin
		it "Should show correct Unit types on availability page" do
			@objReservableAvailability.checkUnitType()
		end
		#Use: This it passes searchText to searchUnitType method
		it 'Should search Unit type on availability page' do
			@objReservableAvailability.searchUnitType("b")
		end
=end
		it 'C117:To check while searching unit type other than the predefined unit type, "No records found!" message should be displayed.' do
			expect(@objReservableAvailability.unitTypeError("z")).to eq true
		end
	end


	context "Testing Building Elements", :contextDemo => false do
		it 'C116:To check while searching building without selecting city, "No records found!" message should be displayed.', :sanity => true do
			expect(@objReservableAvailability.isErrorInBuilding()).to eq true	#Select City
		end

		#Use: This it passes the City Name to checkBuilding function
		it 'C114:To check Building is displayed as per the selected city', :sanity => true do
			expect(@objReservableAvailability.checkBuilding("Beijing")).to eq true
		end

		it 'To check while searching Building type proper results should be shown according to Building type', :regression => true do 
			expect(@objReservableAvailability.checkPattern("Paris","f")).to eq true
		end
	end


	context "Testing setPresetview Elements", :contextDemo => true do
		#Use: This it passes the Preset View name to setPresetView function 
		it 'should set preset view on availability page', :sanity => true do
			expect(@objReservableAvailability.setPresetView(@testRecords['scenario:4']['SetPresetView'][1])).to eq true
		end

		#Use: This it passes the buttonId to clickButton function
		it 'C103:To check user able to see the availability of building reservables.', :sanity => true do
			@objReservableAvailability.clickButton("btnSubmit")
			#sleep(15)
			#EnziUIUtility.clickElement(@driver,:id,"btnNext")
		end
	end

	context 'Testing related to Reservable Table', :contextDemo => true do
=begin
		it 'should select reservable by clicking checkbox', :sanity => true do      		#In Development
			arrBuildingUnit = @objReservableAvailability.getBuildingUnits
			if arrBuildingUnit.count > 0
			    @objReservableAvailability.selectReservables(arrBuildingUnit[0])
			    @objReservableAvailability.selectReservables(arrBuildingUnit[1])
			else
			   	puts 'No records to display'
			end
		end

		it 'should click on send proposal button', :sanity => true do
			expect(@objReservableAvailability.clickElement("sendProposal")).to eq true	
		end

		it 'C104:To check user able to get the proposal form for a particular building in reservable availability page.', :sanity => true do
		    unitsFlag = @objReservableAvailability.getDriver
		    @objReservableAvailability.checkSendProposalTableUnits()
		    expect(nil).not_to  eq(unitsFlag)
  		end
=end
  		it 'Should get table headers', :sanity => true  do
  			#@objReservableAvailability.getHeaders()
  		end

  		it 'Should get tables all data', :sanity => true  do
  			#@objReservableAvailability.getAllData(false)
  		end

=begin
  		it 'C118:To check when after selecting show records as "Available", only unoccupied buildings will be displayed.', :sanity => true do
  			expect(@objReservableAvailability.checkShowRecord()).to eq true
  		end

  		it 'C53:To check when after selecting show records as "All", all occupied and unoccupied buildings will be displayed.', :sanity => true do
  			@objReservableAvailability.setAvailableFrom('2018-11-22')
			@objReservableAvailability.setCity('Austin')
			@objReservableAvailability.showRecords('All')
			@objReservableAvailability.clickButton("btnSubmit")
  			expect(@objReservableAvailability.checkShowRecord()).to eq false
  		end
=end
  		it 'To check when after selecting include pending contract as "Yes", pending contract and non pending contract available reservables will be displayed', :sanity => true, :pendingDemo => true do
  			@objReservableAvailability.setAvailableFrom('2018-11-22')
			@objReservableAvailability.setCity('Austin')
			@objReservableAvailability.showRecords('All')
  			@objReservableAvailability.selectElement("Yes",:option)
  			@objReservableAvailability.checkPendingContracts()
  		end
	end


=begin
		
=end
		#it 'should show Refresh and Close Button when Submit button is clicked but no record is checked' do

		#end
=begin


		
=end		

=begin
		it 'should Fill details on availability page' do
		    app.getDriver
		    .switchToAvaibiliy
		    .setPresetView(availabilityHash['scenario:1']['presetView'])
		    .setCity(availabilityHash['scenario:1']['city'])
		    .setUnitType(availabilityHash['scenario:1']['unitType'])
		    .showRecords(availabilityHash['scenario:1']['showRecords'])
		     sleep(5)
		     resResponce =  app.getDriver
		    .selectbuildings(availabilityHash['scenario:1']['buildings'])
		   # .clickToSubmit(availabilityHash['scenario:1']['buildings'],
		        #           availabilityHash['scenario:1']['city'],
		        #           availabilityHash['scenario:1']['showRecords'],
		          #         availabilityHash['scenario:1']['unitType'])
		    # Check for avaibility api responce return from page and the responce get back from call to api
		    #expect(resResponce[0]).to eq(resResponce[1])
	  	end
=end
  	
	

	#it "should set the values on Availability Page" do
		#@objReservableAvailability.setAvailability()
	#end

=begin
	it "should Set Values in Availability page" do
		@objReservableAvailability.redirectToAvailability()
		puts "Inside Spec: #{@objReservableAvailability.getDriver.title}"
		#expect(@objReservableAvailability.getDriver.title).to eq "Contacts: Home ~ Salesforce - Unlimited Edition"
	end

	it "Save As Preset View, Submit and Save buttons should be disable when only city is selected" do
			@objReservableAvailability.setCity('Paris')
			expect(@objReservableAvailability.saveAsPresetViewButtonEnabled?()).to eq false
			expect(@objReservableAvailability.saveButtonEnabled?).to eq false	
			expect(@objReservableAvailability.submitButtonEnabled?).to eq false
	end
=end

=begin	after(:all){
		@objReservableAvailability.recordDeletion()
		#salesforce.deleteRecords()
		#@driver.quit
	}
=end
end



=begin
it '' do
			@objReservableAvailability.setMinCapacity(@testRecords['scenario:5']['SetMinCapacity'][4])	#21
			@objReservableAvailability.setMaxCapacity(@testRecords['scenario:6']['SetMaxCapacity'][1])	#20
			#@objReservableAvailability.setMinCapacity(@testRecords['scenario:5']['SetMinCapacity'][6])	#19
		end

		it 'Should show error message for Invalid detail of Min Max Price Range on availability page' do
			@objReservableAvailability.setMinPriceRange(@testRecords['scenario:7']['setMinPriceRange'][1])	#2000
			@objReservableAvailability.setMaxPriceRange(@testRecords['scenario:8']['setMaxPriceRange'][2])	#1500
			@objReservableAvailability.setMinPriceRange(@testRecords['scenario:7']['setMinPriceRange'][3])	#1700
			expect(@objReservableAvailability.checkError()).to eq true
		end

=end