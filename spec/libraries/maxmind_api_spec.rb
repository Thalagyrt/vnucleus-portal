require 'spec_helper'

describe Maxmind::Api::Request do
  context "when the service is available" do
    it "succeeds", vcr: true do
      mock_low_risk

      expect(query_maxmind).to be_successful

      assert_requested
    end

    it "returns a low score for low risk data", vcr: true do
      mock_low_risk

      expect(query_maxmind.risk_score).to be < 10

      assert_requested
    end

    it "returns a high score for high risk data" do
      mock_high_risk

      expect(query_maxmind.risk_score).to be > 10

      assert_requested
    end
  end

  context "when the service returns an error" do
    it "fails" do
      mock_failure

      expect(query_maxmind).to_not be_successful

      assert_requested
    end
  end

  context "when the service does not respond" do
    it "fails" do
      mock_timeout

      expect(query_maxmind).to_not be_successful

      assert_requested
    end
  end

  def assert_requested
    expect(WebMock).to have_requested(:post, 'https://minfraud.maxmind.com/app/ccv2r')
  end

  def mock_low_risk
    stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_return(
        status: 200,
        body: 'distance=7;countryMatch=Yes;countryCode=US;freeMail=No;anonymousProxy=No;binMatch=NA;binCountry=;
                 err=;proxyScore=0.00;ip_region=FL;ip_city=Miami;ip_latitude=25.7052;ip_longitude=-80.4633;
                 binName=;ip_isp=Comcast Cable;ip_org=Comcast Cable;binNameMatch=NA;binPhoneMatch=NA;binPhone=;
                 custPhoneInBillingLoc=NotFound;highRiskCountry=No;queriesRemaining=7923;cityPostalMatch=Yes;
                 shipCityPostalMatch=;maxmindID=ET542TIO;ip_asnum=AS7922 Comcast Cable Communications, Inc.;
                 ip_userType=residential;ip_countryConf=99;ip_regionConf=99;ip_cityConf=92;ip_postalCode=33193;
                 ip_postalConf=42;ip_accuracyRadius=4;ip_netSpeedCell=Cable/DSL;ip_metroCode=528;ip_areaCode=305;
                 ip_timeZone=America/New_York;ip_regionName=Florida;ip_domain=comcast.net;ip_countryName=United States;
                 ip_continentCode=NA;ip_corporateProxy=No;riskScore=0.20;prepaid=;
                 minfraud_version=1.3;service_level=standard'
    )
  end

  def mock_high_risk
    stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_return(
        status: 200,
        body: 'distance=15636;explanation=lol;isTransProxy=Yes;countryMatch=No;countryCode=TH;freeMail=No;
                 anonymousProxy=No;binMatch=NA;binCountry=;err=;proxyScore=0.00;ip_region=38;ip_city=Nonthaburi;
                 ip_latitude=13.8622;ip_longitude=100.5134;binName=;ip_isp=True Internet;ip_org=True Internet;
                 binNameMatch=NA;binPhoneMatch=NA;binPhone=;custPhoneInBillingLoc=NotFound;highRiskCountry=Yes;
                 queriesRemaining=7924;cityPostalMatch=Yes;shipCityPostalMatch=;maxmindID=X9O6H6PD;
                 ip_asnum=AS17552 True Internet Co.,Ltd.;ip_userType=residential;ip_countryConf=99;ip_regionConf=9;
                 ip_cityConf=9;ip_postalCode=;ip_postalConf=;ip_accuracyRadius=13;ip_netSpeedCell=Dialup;
                 ip_metroCode=0;ip_areaCode=0;ip_timeZone=Asia/Bangkok;ip_regionName=Nonthaburi;
                 ip_domain=asianet.co.th;ip_countryName=Thailand;ip_continentCode=AS;ip_corporateProxy=No;
                 riskScore=100;prepaid=;minfraud_version=1.3;service_level=standard'
    )
  end

  def mock_failure
    stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_return(
        status: 500, body: ''
    )
  end

  def mock_timeout
    stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_timeout
  end

  def query_maxmind
    described_class.new(Rails.configuration.maxmind_license_key, {email: 'example@example.com'}).response
  end
end