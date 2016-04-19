require 'test_helper'

class ConceptopersonalesControllerTest < ActionController::TestCase
  setup do
    @conceptopersonal = conceptopersonales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conceptopersonales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conceptopersonal" do
    assert_difference('Conceptopersonal.count') do
      post :create, conceptopersonal: { nombre: @conceptopersonal.nombre, tipo_de_concepto: @conceptopersonal.tipo_de_concepto }
    end

    assert_redirected_to conceptopersonal_path(assigns(:conceptopersonal))
  end

  test "should show conceptopersonal" do
    get :show, id: @conceptopersonal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conceptopersonal
    assert_response :success
  end

  test "should update conceptopersonal" do
    patch :update, id: @conceptopersonal, conceptopersonal: { nombre: @conceptopersonal.nombre, tipo_de_concepto: @conceptopersonal.tipo_de_concepto }
    assert_redirected_to conceptopersonal_path(assigns(:conceptopersonal))
  end

  test "should destroy conceptopersonal" do
    assert_difference('Conceptopersonal.count', -1) do
      delete :destroy, id: @conceptopersonal
    end

    assert_redirected_to conceptopersonales_path
  end
end
