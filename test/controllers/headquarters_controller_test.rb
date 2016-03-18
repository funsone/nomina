require 'test_helper'

class HeadquartersControllerTest < ActionController::TestCase
  setup do
    @headquarter = headquarters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:headquarters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create headquarter" do
    assert_difference('Headquarter.count') do
      post :create, headquarter: { nombre: @headquarter.nombre }
    end

    assert_redirected_to headquarter_path(assigns(:headquarter))
  end

  test "should show headquarter" do
    get :show, id: @headquarter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @headquarter
    assert_response :success
  end

  test "should update headquarter" do
    patch :update, id: @headquarter, headquarter: { nombre: @headquarter.nombre }
    assert_redirected_to headquarter_path(assigns(:headquarter))
  end

  test "should destroy headquarter" do
    assert_difference('Headquarter.count', -1) do
      delete :destroy, id: @headquarter
    end

    assert_redirected_to headquarters_path
  end
end
