require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { apellidos: @person.apellidos, correo: @person.correo, direccion: @person.direccion, estado_civil: @person.estado_civil, fecha_de_nacimiento: @person.fecha_de_nacimiento, grado: @person.grado, nombres: @person.nombres, payroll_id: @person.payroll_id, sexo: @person.sexo, status: @person.status, telefono_fijo: @person.telefono_fijo, telefono_movil: @person.telefono_movil, tipo_cedula: @person.tipo_cedula }
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "should show person" do
    get :show, id: @person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person
    assert_response :success
  end

  test "should update person" do
    patch :update, id: @person, person: { apellidos: @person.apellidos, correo: @person.correo, direccion: @person.direccion, estado_civil: @person.estado_civil, fecha_de_nacimiento: @person.fecha_de_nacimiento, grado: @person.grado, nombres: @person.nombres, payroll_id: @person.payroll_id, sexo: @person.sexo, status: @person.status, telefono_fijo: @person.telefono_fijo, telefono_movil: @person.telefono_movil, tipo_cedula: @person.tipo_cedula }
    assert_redirected_to person_path(assigns(:person))
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person
    end

    assert_redirected_to people_path
  end
end
