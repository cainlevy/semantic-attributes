# Requires that an attribute be in a list of valid USA states.
# Machine format is the abbreviation, human format is the whole word.
# List acquired from: http://www.usps.com/ncsc/lookups/abbr_state.txt
#
# ==Options
# * :with_territories [boolean, default false] - whether to allow territories
class Predicates::UsaState < Predicates::Aliased
  # a boolean for whether to allow united states territories. default is false.
  attr_writer :with_territories
  def with_territories?
    @with_territories ? true : false
  end

  def options
    @options ||= STATES.merge(with_territories? ? TERRITORIES : {})
  end
  undef_method :options=

  def error_message
    @error_message || "must be a US state#{' or territory' if with_territories?}."
  end

  TERRITORIES = {
    'American Samoa' => 'AS',
    'Federated States of Micronesia' => 'FM',
    'Guam' => 'GU',
    'Marshall Islands' => 'MH',
    'Northern Mariana Islands' => 'MP',
    'Palau' => 'PW',
    'Puerto Rico' => 'PR',
    'Virgin Islands' => 'VI'
  }

  STATES = {
    'Alabama' => 'AL',
    'Alaska' => 'AK',
    'Arizona' => 'AZ',
    'Arkansas' => 'AR',
    'California' => 'CA',
    'Colorado' => 'CO',
    'Connecticut' => 'CT',
    'Delaware' => 'DE',
    'District of Columbia' => 'DC',
    'Florida' => 'FL',
    'Georgia' => 'GA',
    'Hawaii' => 'HI',
    'Idaho' => 'ID',
    'Illinois' => 'IL',
    'Indiana' => 'IN',
    'Iowa' => 'IA',
    'Kansas' => 'KS',
    'Kentucky' => 'KY',
    'Louisiana' => 'LA',
    'Maine' => 'ME',
    'Maryland' => 'MD',
    'Massachusetts' => 'MA',
    'Michigan' => 'MI',
    'Minnesota' => 'MN',
    'Mississippi' => 'MS',
    'Missouri' => 'MO',
    'Montana' => 'MT',
    'Nebraska' => 'NE',
    'Nevaga' => 'NV',
    'New Hampshire' => 'NH',
    'New Jersey' => 'NJ',
    'New Mexico' => 'NM',
    'New York' => 'NY',
    'North Carolina' => 'NC',
    'North Dakota' => 'ND',
    'Ohio' => 'OH',
    'Oklahoma' => 'OK',
    'Oregon' => 'OR',
    'Pennsylvania' => 'PA',
    'Rhode Island' => 'RI',
    'South Carolina' => 'SC',
    'South Dakota' => 'SD',
    'Tennessee' => 'TN',
    'Texas' => 'TX',
    'Utah' => 'UT',
    'Vermont' => 'VT',
    'Virginia' => 'VA',
    'Washington' => 'WA',
    'West Virginia' => 'WV',
    'Wisconsin' => 'WI',
    'Wyoming' => 'WY'
  }
end