# def create
#   provides :xml, :js, :json, :yaml
#   
#   success 'Created new page', Created
#   failure 'Failed to create new page'
#
#   response :unauthorized, "You cannot do that!", Unauthorized, :redirect => slice_url(:page_index, 'home') do
#     render :template => 'shared/oops'
#   end
#       
#   handle_response do
#     ...
#     respond :unauthorized # or :success, :failure, :invalid_request, :invalid_form
#   end
# end

module LplSupport
  module Merb
  
    class Response
  
      attr_accessor :message, :options, :callback
  
      def initialize(msg, opts = {}, &block)
        @message, @options, @callback = msg, opts, block
      end
   
      def exception
        @exception ||= options[:exception] || ::Merb::ControllerExceptions::OK
      end
      
      def type
        if options[:type]
          options[:type].to_sym
        elsif exception <= ::Merb::ControllerExceptions::ClientError || 
          exception <= ::Merb::ControllerExceptions::ServerError
          :failure
        else
          :success
        end
      end
    
      def raise_exception?
        options[:raise]
      end
   
      def redirect?
        options.key?(:redirect)
      end
    
      def url
        options[:redirect]
      end
    
      def callback?
        callback.is_a?(Proc)
      end
    
      def to_json(*a)
        user_message.to_json
      end
    
      def user_message
        { type => message }
      end
   
    end
  
    module ResponseHandling
    
      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          class_inheritable_accessor :class_provided_responses
          self.class_provided_responses = Hash.new(Merb::Response.new('OK'))
          self.success 'Request was handled successfully'
          self.failure 'Failed to handle the request', :raise => true
          self.response :invalid_form,    "Please correct the form", ::Merb::ControllerExceptions::BadRequest
          self.response :invalid_request, "Invalid request", ::Merb::ControllerExceptions::BadRequest, :raise => true
        end
      end
    
      module ClassMethods
      
        def response(type, msg, *args, &block)
          class_provided_responses[type] = define_response(msg, *args, &block)
        end

        def success(msg, *args, &block)
          class_provided_responses[:success] = define_success(msg, *args, &block)
        end

        def failure(msg, *args, &block)
          class_provided_responses[:failure] = define_failure(msg, *args, &block)
        end
      
        def define_response(msg, *args, &block)
          opts = args.last.is_a?(Hash) ? args.pop : {}
          opts[:exception] ||= args.first
          Merb::Response.new(msg, opts, &block)
        end

        def define_success(msg, *args, &block)
          opts = args.last.is_a?(Hash) ? args.pop : {}
          opts[:exception] ||= args.first || ::Merb::ControllerExceptions::OK
          define_response(msg, opts, &block)
        end

        def define_failure(msg, *args, &block)
          opts = args.last.is_a?(Hash) ? args.pop : {}
          opts[:exception] ||= args.first || ::Merb::ControllerExceptions::InternalServerError
          define_response(msg, opts, &block)
        end
      
      end
    
      protected

      def handle_response(default = nil, &block)
        caught = catch(:response, &block)
        case caught
          when Array  then send_response(_provided_responses[caught[0]], &caught[1])
          when Symbol then send_response(_provided_responses[caught])
          when Proc   then self.instance_eval(&caught)
          else default ? send_response(_provided_responses[default]) : caught
        end
      end
      
      def respond(sym, &block)
        throw(:response, block_given? ? [sym, block] : sym)
      end
    
      def send_response(r, &block)
        if r.callback? && !block_given?
          self.instance_eval(&r.callback)
        elsif r.respond_to?(m = :"to_#{content_type}")
          r.send(m)
        elsif content_type == :html
          if r.redirect?
            redirect r.url, :message => r.user_message
          elsif r.raise_exception?
            raise r.exception
          else
            self.message.update(r.user_message)
            self.instance_eval(&block) if block_given?
          end 
        else
          raise r.exception
        end
      end

      def response(type, msg, *args, &block)
        _provided_responses[type] = self.class.define_response(msg, *args, &block)
      end

      def success(msg, *args, &block)
        _provided_responses[:success] = self.class.define_success(msg, *args, &block)
      end

      def failure(msg, *args, &block)
        _provided_responses[:failure] = self.class.define_failure(msg, *args, &block)
      end
    
      def _provided_responses
        @_provided_responses ||= class_provided_responses.dup
      end
    
    end
  
  end
end

Merb::Controller.send(:include, LplSupport::Merb::ResponseHandling)