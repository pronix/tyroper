require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/customers/index.html.erb" do
  include CustomersHelper
  
  before(:each) do
    assigns[:customers] = [
      stub_model(Customer,
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
      ),
      stub_model(Customer,
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
    ]
  end

  it "renders a list of customers" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for yur_adress".to_s, 2)
    response.should have_tag("tr>td", "value for fiz_adress".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for r_s4".to_s, 2)
    response.should have_tag("tr>td", "value for bank".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for director".to_s, 2)
  end
end

