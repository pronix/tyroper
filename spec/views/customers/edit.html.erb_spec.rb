require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/customers/edit.html.erb" do
  include CustomersHelper
  
  before(:each) do
    assigns[:customer] = @customer = stub_model(Customer,
      :new_record? => false,
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

  it "renders the edit customer form" do
    render
    
    response.should have_tag("form[action=#{customer_path(@customer)}][method=post]") do
      with_tag('textarea#customer_name[name=?]', "customer[name]")
      with_tag('textarea#customer_yur_adress[name=?]', "customer[yur_adress]")
      with_tag('textarea#customer_fiz_adress[name=?]', "customer[fiz_adress]")
      with_tag('input#customer_phone[name=?]', "customer[phone]")
      with_tag('input#customer_ogrn[name=?]', "customer[ogrn]")
      with_tag('input#customer_inn[name=?]', "customer[inn]")
      with_tag('input#customer_kpp[name=?]', "customer[kpp]")
      with_tag('textarea#customer_r_s4[name=?]', "customer[r_s4]")
      with_tag('textarea#customer_bank[name=?]', "customer[bank]")
      with_tag('input#customer_bik[name=?]', "customer[bik]")
      with_tag('textarea#customer_director[name=?]', "customer[director]")
    end
  end
end


