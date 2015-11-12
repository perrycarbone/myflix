require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
  {
    "id"=> "evt_1764f3LLwkS6PWMdIhpFIRot",
    "object"=> "event",
    "api_version"=> "2015-10-16",
    "created"=> 1447271621,
    "data"=> {
      "object"=> {
        "id"=> "ch_1764f3LLwkS6PWMdvK1mtYkR",
        "object"=> "charge",
        "amount"=> 999,
        "amount_refunded"=> 0,
        "application_fee"=> nil,
        "balance_transaction"=> "txn_1764f3LLwkS6PWMddxC98Cya",
        "captured"=> true,
        "created"=> 1447271621,
        "currency"=> "usd",
        "customer"=> "cus_7Kk9wAEgMMRbWc",
        "description"=> nil,
        "destination"=> nil,
        "dispute"=> nil,
        "failure_code"=> nil,
        "failure_message"=> nil,
        "fraud_details"=> {},
        "invoice"=> "in_1764f3LLwkS6PWMdVmhzj9PE",
        "livemode"=> false,
        "metadata"=> {},
        "paid"=> true,
        "receipt_email"=> nil,
        "receipt_number"=> nil,
        "refunded"=> false,
        "refunds"=> {
          "object"=> "list",
          "data"=> [],
          "has_more"=> false,
          "total_count"=> 0,
          "url"=> "/v1/charges/ch_1764f3LLwkS6PWMdvK1mtYkR/refunds"
        },
        "shipping"=> nil,
        "source"=> {
          "id"=> "card_1764f2LLwkS6PWMdENElEmdC",
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
          "customer"=> "cus_7Kk9wAEgMMRbWc",
          "cvc_check"=> "pass",
          "dynamic_last4"=> nil,
          "exp_month"=> 11,
          "exp_year"=> 2016,
          "fingerprint"=> "NPPbD705xls3U9sP",
          "funding"=> "credit",
          "last4"=> "4242",
          "metadata"=> {},
          "name"=> nil,
          "tokenization_method"=> nil
        },
        "statement_descriptor"=> nil,
        "status"=> "succeeded"
      }
    },
    "livemode"=> false,
    "pending_webhooks"=> 1,
    "request"=> "req_7Kk9wST4hMVz6h",
    "type"=> "charge.succeeded"
  }
  end

  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it 'creates a payment associated with the user', :vcr do
    bob = Fabricate(:user, customer_token: 'cus_7Kk9wAEgMMRbWc')
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(bob)
  end

  it 'creates the payment with the amount', :vcr do
    bob = Fabricate(:user, customer_token: 'cus_7Kk9wAEgMMRbWc')
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it 'creates the payment with reference_id', :vcr do
    bob = Fabricate(:user, customer_token: 'cus_7Kk9wAEgMMRbWc')
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq('ch_1764f3LLwkS6PWMdvK1mtYkR')
  end
end
