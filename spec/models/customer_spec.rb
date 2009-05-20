require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Customer do
  before(:each) do
    @valid_attributes = {
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
    }
  end

  it "should create a new instance given valid attributes" do
    Customer.create!(@valid_attributes)
  end
end
