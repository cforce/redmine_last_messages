class LastMessagesHooks < Redmine::Hook::ViewListener


    def view_welcome_index_right(context = { })
      if !User.current.projects.any?
        return ''
      end
      if !Object.const_defined?('HomeBlock') || HomeBlock.find_by_name('forum_messages') 
        messages =  Message.find(:all, :limit => 5,
                                       :order => "#{Message.table_name}.created_on DESC",
                                       :conditions => "#{Board.table_name}.project_id in (#{User.current.projects.collect{|m| m.id}.join(',')})",
                                       :include => [:author, :board])
      
        if context[:hook_caller].respond_to?(:render)
          context[:hook_caller].send(:render, {:locals => {:messages => messages}.merge(context), :partial => "/messages/message_box"})
        elsif context[:controller].is_a?(ActionController::Base)
          context[:controller].send(:render_to_string, {:locals => {:messages => messages}.merge(context), :partial => "/messages/message_box"})
        end
      end
  
    end

    def view_projects_show_right(context = { })
      project = context[:project]
      if !Object.const_defined?('OverviewBlock') || OverviewBlock.find_by_project_id_and_name(project,'forum_messages')
        messages =  Message.find(:all, :limit => 5,
                                       :order => "#{Message.table_name}.created_on DESC",
                                       :conditions => "#{Board.table_name}.project_id = (#{context[:project].id})",
                                       :include => [:author, :board])
        if context[:hook_caller].respond_to?(:render)
          context[:hook_caller].send(:render, {:locals => {:messages => messages}.merge(context), :partial => "/messages/message_box"})
        elsif context[:controller].is_a?(ActionController::Base)
          context[:controller].send(:render_to_string, {:locals => {:messages => messages}.merge(context), :partial => "/messages/message_box"})
        end
      end
    end

end