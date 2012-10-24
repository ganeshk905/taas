require "server"
require "taas_client"

class TaaS
  def self.start_server(contract_file)
      ContractManager.load_contract(contract_file)
      CommandExecuter.execute_command("ruby server.rb",File.dirname(__FILE__))
  end

  def self.client(url,timeout)
    TaaSClient.new(url,timeout)
  end
end
