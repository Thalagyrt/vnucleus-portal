module Common
  module SolusHelpers
    def stub_solus_request(action, options, response)
      allow(Solus::Api::Request).to receive(:new).with(anything, anything, anything, action, options).and_return(double(response: response))
    end
  end
end