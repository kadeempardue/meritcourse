module FormHelper
  def add_classes_to_form_fields(field_hashes)
    field_hashes.each_with_index do |field_hash, i|
      if field_hash["type"] == "text"
        field_hashes[i]["className"] = "uk-input uk-form-width-large text-black ml-2"  
      end
    end
    field_hashes
  end
end
