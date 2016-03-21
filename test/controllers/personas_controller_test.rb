require 'test_helper'

class PersonasControllerTest < ActionController::TestCase
  setup do
    @persona = personas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create persona" do
    assert_difference('Persona.count') do
      post :create, persona: { apellidos: @persona.apellidos, cargas_familiares: @persona.cargas_familiares, cargo_id: @persona.cargo_id, cedula: @persona.cedula, correo: @persona.correo, direccion: @persona.direccion, fecha_de_nacimiento: @persona.fecha_de_nacimiento, nombres: @persona.nombres, sexo: @persona.sexo, status: @persona.status, telefono_fijo: @persona.telefono_fijo, telefono_movil: @persona.telefono_movil, tipo_de_cedula: @persona.tipo_de_cedula }
    end

    assert_redirected_to persona_path(assigns(:persona))
  end

  test "should show persona" do
    get :show, id: @persona
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @persona
    assert_response :success
  end

  test "should update persona" do
    patch :update, id: @persona, persona: { apellidos: @persona.apellidos, cargas_familiares: @persona.cargas_familiares, cargo_id: @persona.cargo_id, cedula: @persona.cedula, correo: @persona.correo, direccion: @persona.direccion, fecha_de_nacimiento: @persona.fecha_de_nacimiento, nombres: @persona.nombres, sexo: @persona.sexo, status: @persona.status, telefono_fijo: @persona.telefono_fijo, telefono_movil: @persona.telefono_movil, tipo_de_cedula: @persona.tipo_de_cedula }
    assert_redirected_to persona_path(assigns(:persona))
  end

  test "should destroy persona" do
    assert_difference('Persona.count', -1) do
      delete :destroy, id: @persona
    end

    assert_redirected_to personas_path
  end
end
