# KsMyVoteInfo is a Ruby gem that interacts with the Kansas SOS voter registration site.
#
# Copyright 2018 by Peter Karman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# dependencies
require 'pp'
require 'mechanize'
require 'nokogiri'

class KsMyVoteInfo
  SERVICE_URL = 'https://myvoteinfo.voteks.org/VoterView/RegistrantSearch.do'.freeze

  COUNTY_CODES = {
    Allen: 308700,
    Anderson: 308800,
    Atchison: 305500,
    Barber: 305700,
    Barton: 301000,
    Bourbon: 308900,
    Brown: 305200,
    Butler: 307200,
    Chase: 301900,
    Chautauqua: 307300,
    Cherokee: 310500,
    Cheyenne: 302900,
    Clark: 304100,
    Clay: 301100,
    Cloud: 301200,
    Coffey: 307400,
    Comanche: 305800,
    Cowley: 307500,
    Crawford: 301300,
    Decatur: 302500,
    Dickinson: 303900,
    Doniphan: 308000,
    Douglas: 301800,
    Edwards: 308200,
    Elk: 307600,
    Ellis: 300100,
    Ellsworth: 303500,
    Finney: 310100,
    Ford: 304200,
    Franklin: 301600,
    Geary: 308600,
    Gove: 309400,
    Graham: 302800,
    Grant: 304300,
    Gray: 304400,
    Greeley: 310300,
    Greenwood: 307700,
    Hamilton: 308400,
    Harper: 305900,
    Harvey: 303600,
    Haskell: 304500,
    Hodgeman: 308300,
    Jackson: 305300,
    Jefferson: 301700,
    Jewell: 302600,
    Johnson: 305600,
    Kearny: 308100,
    Kingman: 306000,
    Kiowa: 306100,
    Labette: 309000,
    Lane: 309600,
    Leavenworth: 301500,
    Lincoln: 303700,
    Linn: 309100,
    Logan: 309700,
    Lyon: 300200,
    Marion: 303800,
    Marshall: 305400,
    McPherson: 304000,
    Meade: 304600,
    Miami: 300300,
    Mitchell: 307100,
    Montgomery: 309300,
    Morris: 302000,
    Morton: 304700,
    Nemaha: 304900,
    Neosho: 309200,
    Ness: 309500,
    Norton: 303000,
    Osage: 302100,
    Osborne: 306700,
    Ottawa: 306800,
    Pawnee: 308500,
    Phillips: 306600,
    Pottawatomie: 305000,
    Pratt: 306200,
    Rawlins: 302300,
    Reno: 303200,
    Republic: 306500,
    Rice: 303300,
    Riley: 300400,
    Rooks: 306900,
    Rush: 310400,
    Russell: 303400,
    Saline: 300600,
    Scott: 309800,
    Sedgwick: 300500,
    Seward: 304800,
    Shawnee: 301400,
    Sheridan: 302400,
    Sherman: 300900,
    Smith: 307000,
    Stafford: 306300,
    Stanton: 300700,
    Stevens: 310200,
    Sumner: 306400,
    Thomas: 303100,
    Trego: 302700,
    Wabaunsee: 302200,
    Wallace: 309900,
    Washington: 305100,
    Wichita: 310000,
    Wilson: 307800,
    Woodson: 307900,
    Wyandotte: 300800,
  }

  def lookup(first_name:, last_name:, dob:, county:)
    resp = send_query(first_name: first_name, last_name: last_name, dob: dob, county: county)
    return unless resp
    doc = Nokogiri::HTML(resp)
    details = doc.search('#registrant')
    details.to_xhtml(indent: 3)
  end

  private

  def send_query(first_name:, last_name:, dob:, county:)
    dob_date = Date.parse(dob)
    payload = {
      action: 'Search',
      dobMonth: dob_date.strftime('%m'),
      dobDay: dob_date.strftime('%d'),
      dobYear: dob_date.year,
      county: county_code(county),
      nameFirst: first_name,
      nameLast: last_name,
    }
    #pp payload
    agent = Mechanize.new
    reg_details = nil
    agent.get SERVICE_URL do |reg_form|
      resp_page = reg_form.form_with(name: 'registrantSearchForm') do |form|
        payload.each do |name, value|
          form[name.to_s] = value
        end
      end.submit

      resp = resp_page.body
      if resp.match(/no records were found/)
        #puts "No match"
      elsif resp.match(/Registrant Detail/)
        #puts "match!"
        reg_details = resp
      end
    end
    reg_details
  end

  def county_code(county)
    code = COUNTY_CODES[county.to_sym]
    if !code
      fail "Unrecognized county: #{county}"
    end
    code
  end
end
