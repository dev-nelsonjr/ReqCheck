class AntigenAdministeredRecord
  include ActiveModel::Model

  attr_accessor :antigen, :vaccine_dose

  def initialize(antigen:, vaccine_dose:)
    @antigen      = antigen
    @vaccine_dose = vaccine_dose
  end

  def self.create_records_from_vaccine_doses(vaccine_doses)
    antigen_records = []
    vaccine_doses.each do |vaccine_dose|
      vaccine_dose.antigens.each do |antigen|
        antigen_records << self.new(antigen: antigen, vaccine_dose: vaccine_dose)
      end
    end
    antigen_records
  end

  def vaccine_info
    self.vaccine_dose.vaccine_info
  end

  def cdc_attributes
    full_name = self.vaccine_info.nil? ? nil : self.vaccine_info.full_name
    {
      antigen: self.antigen.name,
      date_administered: self.vaccine_dose.administered_date,
      cvx_code: self.vaccine_dose.cvx_code,
      mvx_code: self.vaccine_dose.mvx_code,
      trade_name: full_name,
      amount: self.vaccine_dose.dosage,
      lot_expiration_date: self.vaccine_dose.expiration_date
    }
  end
end