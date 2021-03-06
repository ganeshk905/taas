require File.join($PROJECT_ROOT, 'lib', 'helper', 'contracts')
require File.join($PROJECT_ROOT, 'test',"test_helper")


class ContractsTest < Test::Unit::TestCase

  CONTRACT_HASH = {"contracts"=>{
      "create_live_sale"=>
          {"command"=>"bundle exec cucumber",
           "dir"=>"/home/tworker/work/livesale-automation",
           "input_params"=>{"name"=>nil, "no_of_listing"=>nil},
           "timeout_in_seconds"=>100,
           "output_params"=>{"live_sale_id"=>nil}},
      "end_live_sale"=>
          {"command"=>"bundle exec cucumber",
           "dir"=>"/home/tworker/work/livesale-automation",
           "input_params"=>{"live_sale_id"=>nil},
           "timeout_in_seconds"=>100,
           "output_params"=>{"actual_end_time"=>nil}}}}

  context "load" do
    should "load the valid contract from contract file" do
      contract_file_absolute_path = "a1/a5"
      YAML.stubs(:load_file).with(contract_file_absolute_path).returns(CONTRACT_HASH)

      Contracts.load(contract_file_absolute_path)

      assert_equal false,Contracts.is_empty?
    end

    should "not load contract if contract file is not present" do
      contract_file_absolute_path = "a1/a2"
      YAML.stubs(:load_file).with(contract_file_absolute_path).returns({})

      Contracts.load(contract_file_absolute_path)

      assert_equal true,Contracts.is_empty?
    end

    should "raise execption if empty or nil contract file is passesd" do
      assert_raise do
        Contracts.load(nil)
      end
      assert_raise do
        Contracts.load("")
      end

    end
  end

  context "get_contract" do
    setup {
      @contract_file_absolute_path = "a1/a2"
      @contract_name = "create_live_sale"
    }
    should "should return the contract object of given contract" do
      YAML.stubs(:load_file).with(@contract_file_absolute_path).returns(CONTRACT_HASH)
      Contracts.load(@contract_file_absolute_path)

      assert_equal CONTRACT_HASH["contracts"][@contract_name]["command"],Contracts.get_contract(@contract_name).value_of("command")
    end

    should "return nil if contract is not present" do
      YAML.stubs(:load_file).with(@contract_file_absolute_path).returns(CONTRACT_HASH)
      Contracts.load(@contract_file_absolute_path)

      assert_nil Contracts.get_contract("dummy")
    end
  end

  context "is_valid_contract?" do
    setup {
      @contract_file_absolute_path = "a1/a2"
      @contract_name = :create_live_sale
      YAML.stubs(:load_file).with(@contract_file_absolute_path).returns(CONTRACT_HASH)
      Contracts.load(@contract_file_absolute_path)
    }
    should "return true if requested contract is present" do
       assert Contracts.contains?("create_live_sale")
    end
    should "return false if requested contract is not present" do
      assert_false Contracts.contains?("dummy_contract")
    end
  end

  context "get_all_contracts" do
    setup {
      @contract_file_absolute_path = "a1/a2"
      @contract_name = :create_live_sale
      YAML.stubs(:load_file).with(@contract_file_absolute_path).returns(CONTRACT_HASH)
      Contracts.load(@contract_file_absolute_path)
    }
    should "return all the contracts" do
      assert_equal CONTRACT_HASH["contracts"],Contracts.get_all_contracts
    end
  end
end