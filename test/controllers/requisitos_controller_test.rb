require 'test_helper'

class RequisitosControllerTest < ActionController::TestCase
  setup do
    @requisito = requisitos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:requisitos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create requisito" do
    assert_difference('Requisito.count') do
      post :create, requisito: { nombre: @requisito.nombre }
    end

    assert_redirected_to requisito_path(assigns(:requisito))
  end

  test "should show requisito" do
    get :show, id: @requisito
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @requisito
    assert_response :success
  end

  test "should update requisito" do
    patch :update, id: @requisito, requisito: { nombre: @requisito.nombre }
    assert_redirected_to requisito_path(assigns(:requisito))
  end

  test "should destroy requisito" do
    assert_difference('Requisito.count', -1) do
      delete :destroy, id: @requisito
    end

    assert_redirected_to requisitos_path
  end
end
