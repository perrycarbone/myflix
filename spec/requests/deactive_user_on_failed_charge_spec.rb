require 'spec_helper'

describe "Deactives user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_176QFZLLwkS6PWMdl3N7dXP6",
      "object"=> "event",
      "api_version"=> "2015-10-16",
      "created"=> 1447354609,
      "data"=> {
        "object"=> {
          "id"=> "ch_176QFZLLwkS6PWMdJ1ezYTlY",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil,
          "balance_transaction"=> nil,
          "captured"=> false,
          "created"=> 1447354609,
          "currency"=> "usd",
          "customer"=> "cus_7KrfCIMADdtGZW",
          "description"=> "payment to fail test",
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> "card_declined",
          "failure_message"=> "Your card was declined.",
          "fraud_details"=> {},
          "invoice"=> nil,
          "livemode"=> false,
          "metadata"=> {},
          "paid"=> false,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_176QFZLLwkS6PWMdJ1ezYTlY/refunds"
          },
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_176QDzLLwkS6PWMdku9kwa42",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_7KrfCIMADdtGZW",
            "cvc_check"=> nil,
            "dynamic_last4"=> nil,
            "exp_month"=> 11,
            "exp_year"=> 2016,
            "fingerprint"=> "XRuoPDK3FFPu2OEd",
            "funding"=> "credit",
            "last4"=> "0341",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "statement_descriptor"=> "MyFlix Monthly Charge",
          "status"=> "failed"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_7L6SZ4lptJhTOu",
      "type"=> "charge.failed"
    }
  end

  it "deactives the user with the web hook data from stripe for a charge failed", :vcr do
    bob = Fabricate(:user, customer_token: 'cus_7KrfCIMADdtGZW')
    post '/stripe_events', event_data
    expect(bob.reload).not_to be_active
  end
end
