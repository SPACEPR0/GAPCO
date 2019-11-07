require "application_system_test_case"

class EvidencefilesTest < ApplicationSystemTestCase
  setup do
    @evidencefile = evidencefiles(:one)
  end

  test "visiting the index" do
    visit evidencefiles_url
    assert_selector "h1", text: "Evidencefiles"
  end

  test "creating a Evidencefile" do
    visit evidencefiles_url
    click_on "New Evidencefile"

    click_on "Create Evidencefile"

    assert_text "Evidencefile was successfully created"
    click_on "Back"
  end

  test "updating a Evidencefile" do
    visit evidencefiles_url
    click_on "Edit", match: :first

    click_on "Update Evidencefile"

    assert_text "Evidencefile was successfully updated"
    click_on "Back"
  end

  test "destroying a Evidencefile" do
    visit evidencefiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Evidencefile was successfully destroyed"
  end
end
