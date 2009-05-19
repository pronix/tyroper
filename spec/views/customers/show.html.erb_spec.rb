require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/customers/show.html.erb" do
  include CustomersHelper
  before(:each) do
    assigns[:customer] = @customer = stub_model(Customer,
      :name => "value for name",
      :yur_adress => "value for yur_adress",
      :fiz_adress => "value for fiz_adress",
      :phone => 1,
      :ogrn => 1,
      :inn => 1,
      :kpp => 1,
      :r_s4 => "value for r_s4",
      :bank => "value for bank",
      :bik => 1,
      :director => "value for director"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ yur_adress/)
    response.should have_text(/value\ for\ fiz_adress/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ r_s4/)
    response.should have_text(/value\ for\ bank/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ director/)
  end
end

