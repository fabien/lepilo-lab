module LplSupport::Merb::Controller::Mixins::Support
          
  def append_query_params(qp)
    request.path + '?' + request.send(:query_params).merge(qp).to_params
  end
  
end

Merb::Controller.send(:include, LplSupport::Merb::Controller::Mixins::Support)