class Admin::PaymentsController < AdminsController
  before_action :require_admin

def index
  @payments = Payment.all
end

end
