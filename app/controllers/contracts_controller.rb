class ContractsController < ApplicationController
  def show
    @contract = Contract.find(params[:id])
    ids = @contract.package.split(',')
    @package = []
    ids.each do |id|
      pack = Package.find(id)
      @package.push(pack) if pack 
    end
    @ctr_photo = ContractPhotographer.where(contract_id: params[:id])
    uri   = URI.parse(request.fullpath)
    @code = ''
    if uri.query
      params = CGI.parse(uri.query)
      @code  = params['code'].first
    end
  end

  def public_create
    test = params.permit(:school, :name, :group, :code)
    @contract = Contract.new(test)
    if @contract.save
      render json: @contract
    else
      render json: {message: 'cannot create'}
    end
  end

  def scription
    @contract = Contract.find(params[:id])
  end
end
