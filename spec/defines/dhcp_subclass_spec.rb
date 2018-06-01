require 'spec_helper'

describe 'dhcp::dhcp_subclass', type: :define do
  let(:title) { 'test_subclass' }
  let(:header) { ['#################################', "# Custom subclass #{title}", '#################################'] }
  let(:facts) do
    {
      osfamily: 'RedHat',
      os: { family: 'RedHat' }
    }
  end

  context 'with parameters string' do
    let(:params) do
      { 'depends'    => 'vendor-class-identifier' }
      { 'parameters' => 'match option vendor-subclass-identifier' }
    end

    it { is_expected.to contain_concat__fragment("dhcp_subclass_#{title}") }

    it 'creates a subclass declaration' do
      content = catalogue.resource('concat::fragment', "dhcp_subclass_#{title}").send(:parameters)[:content]
      expected_lines = header + [
        %(subclass "#{depends}" "#{title}" \{),
        '  match option vendor-subclass-identifier;',
        '}'
      ]
      expect(content.split("\n")).to match_array(expected_lines)
    end
  end

  context 'with parameters array' do
    let(:params) do
      { 'depends'    => 'vendor-class-identifier' }
      { 'parameters' => ['match option vendor-subclass-identifier', 'match option identifier-2'] }
    end

    it { is_expected.to contain_concat__fragment("dhcp_class_#{title}") }

    it 'creates a subclass declaration' do
      content = catalogue.resource('concat::fragment', "dhcp_subclass_#{title}").send(:parameters)[:content]
      expected_lines = header + [
        %(class "#{depends}" "#{title}" \{),
        '  match option vendor-subclass-identifier;',
        '  match option identifier-2;',
        '}'
      ]
      expect(content.split("\n")).to match_array(expected_lines)
    end
  end
end
