require 'rubycas-client'
require 'sinatra/base'
require 'active_support/core_ext'

module Sinatra
  module CAS
    module Client
      module Helpers
        def authenticated?
          if session[settings.username_session_key]
            puts "User is already identified as #{session[settings.username_session_key]}" if settings.console_debugging
            return true
          end
        end

        def authenticate
          puts "Running CAS filter for request #{request.fullpath}..." if settings.console_debugging
          client = CASClient::Client.new(
            cas_base_url:           settings.cas_base_url,
            force_ssl_verification: settings.verify_ssl
          )
          ticket = params[:ticket]

          cas_login_url = client.add_service_to_login_url(settings.service_url)

          if ticket
            if ticket =~ /^PT-/
              st = CASClient::ProxyTicket.new(ticket, settings.service_url, false)
              puts "User has a ticket (proxy ticket)! #{st.inspect}" if settings.console_debugging
            else
              st = CASClient::ServiceTicket.new(ticket, settings.service_url, false)
              puts "User has a ticket (service ticket)! #{st.inspect}" if settings.console_debugging
            end

            client.validate_service_ticket(st) unless st.has_been_validated?

            if st.is_valid?
              puts 'ticket is valid' if settings.console_debugging if settings.console_debugging
              session[settings.username_session_key] = st.user
              puts "user logged as #{session[settings.username_session_key]}" if settings.console_debugging
              redirect settings.service_url
            else
              puts 'ticket is not valid' if settings.console_debugging
              session[settings.username_session_key] = nil
              redirect cas_login_url
            end
          else
            puts 'No ticket, redirecting to login server' if settings.console_debugging
            session[settings.username_session_key]
            redirect cas_login_url
          end
        end
      end

      def self.registered(app)
        app.helpers CAS::Client::Helpers

        #TODO: setup defaults options
        app.set :cas_base_url, 'https://login.example.com/cas'
        app.set :service_url, 'https://localhost/'
        app.set :verify_ssl, false
        app.set :console_debugging, false
        app.set :username_session_key, :cas_user
        app.set :session_key, 'rack.session'
  
        #unless ENV.include?(settings.session_key)
        #  fail "you need to set up a session middleware *before* #{self.class}"
        #end

        #app.enable :sessions
      end
    end
  end

  register CAS::Client
end
