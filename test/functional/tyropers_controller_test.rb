require 'test_helper'

class TyropersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tyropers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tyroper" do
    assert_difference('Tyroper.count') do
      post :create, :tyroper => { }
    end

    assert_redirected_to tyroper_path(assigns(:tyroper))
  end

  test "should show tyroper" do
    get :show, :id => tyropers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tyropers(:one).to_param
    assert_response :success
  end

  test "should update tyroper" do
    put :update, :id => tyropers(:one).to_param, :tyroper => { }
    assert_redirected_to tyroper_path(assigns(:tyroper))
  end

  test "should destroy tyroper" do
    assert_difference('Tyroper.count', -1) do
      delete :destroy, :id => tyropers(:one).to_param
    end

    assert_redirected_to tyropers_path
  end
end
