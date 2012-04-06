require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'guard/go/runner'

module Guard
  class Go < ::Guard::Guard 
    attr_reader :options
    
    def initialize(watchers = [], options = {})
      super

      defaults = {
        :server => 'app.go'
      }
      
      @runner = ::Guard::GoRunner.new(defaults.merge(options))
    end

    def start
      UI.info "Starting Go..."
      if pid = @runner.start
        UI.info "Started Go app, pid #{pid}"  
      end
    end

    def run_on_change(paths)
      UI.info "Restarting Go..."
      if @runner.restart
        UI.info "Go restarted, pid #{@runner.pid}"
      else
        UI.info "Go NOT restarted, check your log files."
      end
    end

    def stop
      @runner.stop
      UI.info "Stopping Go..."
      Notifier.notify("Until next time...", :title => "Go shutting down.", :image => :pending)
    end
  end
end
