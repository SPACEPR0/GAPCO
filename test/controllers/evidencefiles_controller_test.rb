require 'test_helper'

class EvidencefilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evidencefile = evidencefiles(:one)
  end

  test "should get index" do
    get evidencefiles_url
    assert_response :success
  end

  test "should get new" do
    get new_evidencefile_url
    assert_response :success
  end

  test "should create evidencefile" do
    assert_difference('Evidencefile.count') do
      post evidencefiles_url, params: { evidencefile: {  } }
    end

    assert_redirected_to evidencefile_url(Evidencefile.last)
  end

  test "should show evidencefile" do
    get evidencefile_url(@evidencefile)
    assert_response :success
  end

  test "should get edit" do
    get edit_evidencefile_url(@evidencefile)
    assert_response :success
  end

  test "should update evidencefile" do
    patch evidencefile_url(@evidencefile), params: { evidencefile: {  } }
    assert_redirected_to evidencefile_url(@evidencefile)
  end

  test "should destroy evidencefile" do
    assert_difference('Evidencefile.count', -1) do
      delete evidencefile_url(@evidencefile)
    end

    assert_redirected_to evidencefiles_url
  end
end
