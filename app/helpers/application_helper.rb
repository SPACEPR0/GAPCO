module ApplicationHelper

    def resource_name
        :user
      end

      def resource
        @resource ||= User.new
      end

      def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def link_to_add_file(name, f, association, **args)
      new_obj = f.object.send(association).klass.new
      id = new_obj.object_id
      fields = f.fields_for(association, new_obj, child_index: id) do |builder|
        render(association.to_s.singularize, f: builder)
      end
      link_to(name, '#', class: "add_fields ", id: args[:id], style: "display:none;", data: {id: id, fields: fields.gsub("\n", "")})
    end

end
