require_relative '../test_helper'

class FormTagTest < JavascriptRenderer::ViewTest

  def setup
    reset_renderer do |config|
      config.fonts_path           = '/fonts'
      config.audios_path          = '/audios'
      config.videos_path          = '/videos'
      config.images_path          = '/images'
      config.javascript_path      = ''
      config.stylesheet_path      = ''
      config.protect_from_forgery = true
    end
  end

  FieldTypes = {
    color:         :color,
    date:          :date,
    datetime:      :datetime,
    email:         :email,
    file:          :file,
    hidden:        :hidden,
    month:         :month,
    number:        :number,
    password:      :password,
    range:         :range,
    search:        :search,
    text:          :text,
    time:          :time,
    url:           :url,
    week:          :week,
    datetimeLocal: :'datetime-local',
    telephone:     :tel,
    phone:         :tel
  }

  FieldTypes.each do |field, type|
    define_method :"test_optionsless_#{field}" do
      html_code = %(<input type="#{type}" id="field_name" name="field[name]" value="field_value"/>)
      assert_dom_helper html_code, :"#{field}FieldTag", 'field[name]', 'field_value'

      html_code = %(<input type="#{type}" id="field_name" name="field[name]"/>)
      assert_dom_helper html_code, :"#{field}FieldTag", 'field[name]', nil
    end

    define_method :"test_#{field}_with_options" do
      html_code = %(<input type="#{type}" id="field_name" name="field_name" class="#{field}_class" data-attribute="this is a #{type} field"/>)
      assert_dom_helper html_code, :"#{field}FieldTag", 'field_name', nil, class: "#{field}_class", data: { attribute: "this is a #{type} field" }

      html_code = %(<input type="#{type}" id="field_name" name="field_name" value="field_value" class="#{field}_class" data-attribute="this is a #{type} field"/>)
      assert_dom_helper html_code, :"#{field}FieldTag", 'field_name', 'field_value', class: "#{field}_class", data: { attribute: "this is a #{type} field" }
    end
  end

  def test_button_tag
    assert_dom_helper %(<button name="button" type="submit">Button</button>), :buttonTag
  end

  def test_button_tag_with_submit_type
    assert_dom_helper %(<button name="button" type="submit">Save</button>), :buttonTag, 'Save', type: 'submit'
  end

  def test_button_tag_with_button_type
    assert_dom_helper %(<button name="button" type="button">Button</button>), :buttonTag, 'Button', type: 'button'
  end

  def test_button_tag_with_reset_type
    assert_dom_helper %(<button name="button" type="reset">Reset</button>), :buttonTag, 'Reset', type: 'reset'
  end

  def test_button_tag_with_disabled_option
    assert_dom_helper %(<button name="button" type="reset" disabled="disabled">Reset</button>), :buttonTag, 'Reset', type: 'reset', disabled: true
  end

  def test_button_tag_escape_content
    assert_dom_helper %(<button name="button" type="reset" disabled="disabled"><b>Reset</b></button>), :buttonTag, '<b>Reset</b>', type: 'reset', disabled: true
  end

  def test_button_tag_with_block
    assert_dom_helper('<button name="button" type="submit">Content</button>', :buttonTag){ 'Content' }
  end

  def test_button_tag_with_block_and_options
    html_code = '<button name="temptation" type="button"><strong>Do not press me</strong></button>'
    assert_dom_helper(html_code, :buttonTag, name: 'temptation', type: 'button'){ helper_call :contentTag, :strong, 'Do not press me' }
  end

  def test_button_tag_with_confirmation
    html_code = %(<button name="button" type="submit" data-confirm="Are you sure?">Save</button>)
    assert_dom_helper html_code, :buttonTag, 'Save', type: 'submit', data: { confirm: 'Are you sure?' }
  end

  def test_checkbox_tag
    html_code = %(<input type="checkbox" id="field_name" name="field[name]" value="field_value"/>)
    assert_dom_helper html_code, :checkBoxTag, 'field[name]', 'field_value'

    html_code = %(<input type="checkbox" id="field_name" name="field[name]" value="field_value" checked="checked"/>)
    assert_dom_helper html_code, :checkboxTag, 'field[name]', 'field_value', checked: true

    html_code = %(<input type="checkbox" id="field_name" name="field[name]" value="1"/>)
    assert_dom_helper html_code, :checkBoxTag, 'field[name]'

    html_code = %(<input type="checkbox" id="field_name" value="1" name="field_name" class="checkbox_class" data-attribute="this is a checkbox field"/>)
    assert_dom_helper html_code, :checkboxTag, 'field_name', nil, false, class: "checkbox_class", data: { attribute: "this is a checkbox field" }

    html_code = %(<input type="checkbox" id="field_name" name="field_name" value="field_value" class="checkbox_class" data-attribute="this is a checkbox field"/>)
    assert_dom_helper html_code, :checkBoxTag, 'field_name', 'field_value', false, class: "checkbox_class", data: { attribute: "this is a checkbox field" }

    html_code = %(<input type="checkbox" id="field_name" name="field_name" checked="checked" value="field_value" class="checkbox_class" data-attribute="this is a checkbox field"/>)
    assert_dom_helper html_code, :checkBoxTag, 'field_name', 'field_value', true, class: "checkbox_class", data: { attribute: "this is a checkbox field" }
  end

  def test_fieldset_tag
    html_code = %(<fieldset><legend>Your details</legend>Hello world!</fieldset>)
    assert_dom_helper( html_code, :fieldsetTag, 'Your details' ){ 'Hello world!' }

    html_code = %(<fieldset>Hello world!</fieldset>)
    assert_dom_helper( html_code, :fieldSetTag ){ 'Hello world!' }

    html_code = %(<fieldset>Hello world!</fieldset>)
    assert_dom_helper( html_code, :fieldsetTag, '' ){ 'Hello world!' }

    html_code = %(<fieldset class="format">Hello world!</fieldset>)
    assert_dom_helper( html_code, :fieldSetTag, '', class: 'format' ){ 'Hello world!' }

    html_code = %(<fieldset></fieldset>)
    assert_dom_helper html_code, :fieldSetTag

    html_code = %(<fieldset><legend>You legend!</legend></fieldset>)
    assert_dom_helper html_code, :fieldsetTag, 'You legend!'
  end

  def test_form_tag
    assert_dom_helper whole_form, :formTag
  end

  def test_form_tag_multipart
    expected = whole_form 'http://www.example.com', enctype: true
    assert_dom_helper expected, :formTag, 'http://www.example.com', multipart: true
  end

  def test_form_tag_with_method_patch
    expected = whole_form 'http://www.example.com', method: :patch
    assert_dom_helper expected, :formTag, 'http://www.example.com', method: :patch
  end

  def test_form_tag_with_method_put
    expected = whole_form'http://www.example.com', method: :put
    assert_dom_helper expected, :formTag, 'http://www.example.com', method: :put
  end

  def test_form_tag_with_method_delete
    expected = whole_form 'http://www.example.com', method: :delete
    assert_dom_helper expected, :formTag, 'http://www.example.com', method: :delete
  end

  def test_form_tag_with_remote
    expected = whole_form 'http://www.example.com', remote: true
    assert_dom_helper expected, :formTag, 'http://www.example.com', remote: true
  end

  def test_form_tag_with_remote_false
    expected = whole_form '/', remote: false
    assert_dom_helper expected, :formTag, nil, remote: false
  end

  def test_form_tag_enforce_utf8_true
    expected = whole_form 'http://www.example.com', enforce_utf8: true
    assert_dom_helper expected, :formTag, 'http://www.example.com', enforce_utf8: true
  end

  def test_form_tag_enforce_utf8_false
    expected = whole_form 'http://www.example.com', enforce_utf8: false
    assert_dom_helper expected, :formTag, 'http://www.example.com', enforce_utf8: false
  end

  def test_form_tag_with_block
    expected = whole_form{ 'Hello world!' }
    assert_dom_helper(expected, :formTag){ 'Hello world!' }
    assert_dom_js_helper expected, :formTag, %( function(){ return 'Hello world!';} )
  end

  def test_form_tag_with_block_and_method
    expected = whole_form('http://www.example.com', method: :put){ 'Hello world!' }
    assert_dom_helper(expected, :formTag, 'http://www.example.com', method: :put){ 'Hello world!' }
    assert_dom_js_helper expected, :formTag, %( 'http://www.example.com', { method: 'put' }, function(){ return 'Hello world!';} )
  end

  def test_image_submit_tag
    html_code = %(<input alt="Save" type="image" src="/images/save.gif"/>)
    assert_dom_helper html_code, :imageSubmitTag, 'save.gif'

    html_code = %(<input alt="Save" type="image" src="/images/save.gif" data-confirm="Are you sure?" />)
    assert_dom_helper html_code, :imageSubmitTag, 'save.gif', data: { confirm: 'Are you sure?' }
  end

  def test_label_tag_without_text
    expected = %(<label for="title">Title</label>)
    assert_dom_helper expected, :labelTag, 'title'

    expected = %(<label for="title">Title</label>)
    assert_dom_helper expected, :labelTag, :title
  end

  def test_label_tag_with_text
    expected = %(<label for="title">My Title</label>)
    assert_dom_helper expected, :labelTag, 'title', 'My Title'
  end

  def test_label_tag_class_string
    expected = %(<label for="title" class="small_label">My Title</label>)
    assert_dom_helper expected, :labelTag, 'title', 'My Title', class: 'small_label'
  end

  def test_label_tag_id_sanitized
    expected = %(<label for="item_title">Item title</label>)
    assert_dom_helper expected, :labelTag, 'item[title]'
  end

  def test_label_tag_with_block
    assert_dom_helper('<label>Blocked</label>', :labelTag){ 'Blocked' }
  end

  def test_label_tag_with_block_and_argument
    assert_dom_helper('<label for="clock">Grandfather</label>', :labelTag, 'clock'){ 'Grandfather' }
  end

  def test_label_tag_with_block_and_argument_and_options
    assert_dom_helper('<label for="clock" id="label_clock">Grandfather</label>', :labelTag, 'clock', id: 'label_clock'){ 'Grandfather' }
  end

  def test_radio_button_tag
    expected = %(<input id="people_david" name="people" type="radio" value="david" />)
    assert_dom_helper expected, :radioButtonTag, 'people', 'david'

    expected = %(<input id="num_people_5" name="num_people" type="radio" value="5" />)
    assert_dom_helper expected, :radioButtonTag, 'num_people', 5

    expected = %(<input id="gender_m" name="gender" type="radio" value="m" /><input id="gender_f" name="gender" type="radio" value="f" />)
    assert_dom_javascript expected, %( H.radioButtonTag('gender', 'm') + H.radioButtonTag('gender', 'f') )

    expected = %(<input id="opinion_-1" name="opinion" type="radio" value="-1" /><input id="opinion_1" name="opinion" type="radio" value="1" />)
    assert_dom_javascript expected, %( H.radioButtonTag('opinion', '-1') + H.radioButtonTag('opinion', '1') )

    expected = %(<input id="person_gender_m" name="person[gender]" type="radio" value="m" />)
    assert_dom_helper expected, :radioButtonTag, 'person[gender]', 'm'

    expected = %(<input id="ctrlname_apache2.2" name="ctrlname" type="radio" value="apache2.2" />)
    assert_dom_helper expected, :radioButtonTag, 'ctrlname', 'apache2.2'
  end

  def test_select_tag
    expected = %(<select id="people" name="people"><option>david</option></select>)
    assert_dom_helper expected, :selectTag, 'people', '<option>david</option>'
  end

  def test_select_tag_with_multiple
    expected = %(<select id="colors" multiple="multiple" name="colors"><option>Red</option><option>Blue</option><option>Green</option></select>)
    assert_dom_helper expected, :selectTag, 'colors', '<option>Red</option><option>Blue</option><option>Green</option>', multiple: true
  end

  def test_select_tag_disabled
    expected = %(<select id="places" disabled="disabled" name="places"><option>Home</option><option>Work</option><option>Pub</option></select>)
    assert_dom_helper expected, :selectTag, 'places', '<option>Home</option><option>Work</option><option>Pub</option>', disabled: true
  end

  def test_select_tag_id_sanitized
    expected = %(<select id="project_1people" name="project[1]people"><option>david</option></select>)
    assert_dom_helper expected, :selectTag, 'project[1]people', '<option>david</option>'
  end

  def test_select_tag_with_include_blank
    expected = %(<select id="places" name="places"><option value=""></option><option>Home</option><option>Work</option><option>Pub</option></select>)
    assert_dom_helper expected, :selectTag, 'places', '<option>Home</option><option>Work</option><option>Pub</option>', include_blank: true
  end

  def test_select_tag_with_prompt
    expected = %(<select id="places" name="places"><option value="">string</option><option>Home</option><option>Work</option><option>Pub</option></select>)
    assert_dom_helper expected, :selectTag, 'places', '<option>Home</option><option>Work</option><option>Pub</option>', prompt: 'string'
  end

  def test_select_tag_escapes_prompt
    expected = %(<select id="places" name="places"><option value="">&lt;script&gt;alert(1337)&lt;/script&gt;</option><option>Home</option><option>Work</option><option>Pub</option></select>)
    assert_dom_helper expected, :selectTag, 'places', '<option>Home</option><option>Work</option><option>Pub</option>', prompt: '<script>alert(1337)</script>'
  end

  def test_select_tag_with_prompt_and_include_blank
    expected = %(<select name="places" id="places"><option value="">string</option><option value=""></option><option>Home</option><option>Work</option><option>Pub</option></select>)
    assert_dom_helper expected, :selectTag, 'places', '<option>Home</option><option>Work</option><option>Pub</option>', prompt: 'string', include_blank: true
  end

  def test_select_tag_with_nil_option_tags_and_include_blank
    expected = %(<select id="places" name="places"><option value=""></option></select>)
    assert_dom_helper expected, :selectTag, 'places', nil, include_blank: true
  end

  def test_select_tag_with_nil_option_tags_and_prompt
    expected = %(<select id="places" name="places"><option value="">string</option></select>)
    assert_dom_helper expected, :selectTag, 'places', nil, prompt: 'string'
  end

  def test_submit_tag
    expected = %(<input name='commit' data-disable-with="Saving..." onclick="alert(&#39;hello!&#39;)" type="submit" value="Save" />)
    assert_dom_helper expected, :submitTag, 'Save', onclick: "alert('hello!')", data: { disable_with: 'Saving...' }
  end

  def test_submit_tag_with_no_onclick_options
    expected = %(<input name='commit' data-disable-with="Saving..." type="submit" value="Save" />)
    assert_dom_helper expected, :submitTag, 'Save', data: { disable_with: 'Saving...' }
  end

  def test_submit_tag_with_confirmation
    expected = %(<input name='commit' type='submit' value='Save' data-confirm="Are you sure?" />)
    assert_dom_helper expected, :submitTag, 'Save', data: { confirm: 'Are you sure?' }
  end

  def test_text_area_tag_size
    expected = %(<textarea cols="20" id="body" name="body" rows="40">\nhello world</textarea>)
    assert_dom_helper expected, :textAreaTag, 'body', 'hello world', size: '20x40'
  end

  def test_text_area_tag_should_disregard_size_if_its_given_as_an_integer
    expected = %(<textarea id="body" name="body">\nhello world</textarea>)
    assert_dom_helper expected, :textareaTag, 'body', 'hello world', size: 20
  end

  def test_text_area_tag_id_sanitized
    expected = %(<textarea id="item__description" name="item[][description]">\n</textarea>)
    assert_dom_helper expected, :textAreaTag, 'item[][description]'
  end

  def test_text_area_tag_escape_content
    expected = %(<textarea cols="20" id="body" name="body" rows="40">\n&lt;b&gt;hello\n world&lt;/b&gt;</textarea>)
    assert_dom_helper expected, :textareaTag, 'body', "<b>hello\n world</b>", size: '20x40'
  end

  def test_text_area_tag_unescaped_content
    expected = %(<textarea cols="20" id="body" name="body" rows="40">\n<b>hello world</b></textarea>)
    assert_dom_helper expected, :textareaTag, 'body', '<b>hello world</b>', size: '20x40', escape: false
  end

  def test_text_area_tag_unescaped_nil_content
    expected = %(<textarea id="body" name="body">\n</textarea>)
    assert_dom_helper expected, :textareaTag, 'body', nil, escape: false
  end

  def test_utf8_enforcer_tag
    expected = '<input name="utf8" type="hidden" value="&#x2713;" />'
    assert_dom_helper expected, :utf8EnforcerTag
  end

  protected
  def whole_form(action = '/', options = {})
    output = form_text(action, options) + hidden_fields(options)
    output << yield if block_given?
    output << '</form>'
  end

  def form_text(action = '/', options = {})
    remote, enctype, html_class, id, method = options.values_at(:remote, :enctype, :html_class, :id, :method)

    txt =  %{<form accept-charset="UTF-8" action="#{action}"}

    txt << %{ enctype="multipart/form-data"} if enctype
    txt << %{ data-remote="true"}            if remote
    txt << %{ class="#{html_class}"}         if html_class
    txt << %{ id="#{id}"}                    if id

    txt << %{ method="#{method.to_s == "get" ? "get" : "post"}">}
  end

  def hidden_fields(options = {})
    method          = options[:method]
    enforce_utf8    = options.fetch :enforce_utf8,       true
    csrf_protection = options.fetch :authenticity_token, true

    txt = %{<div style="display:none">}
    txt << %{<input name="utf8" type="hidden" value="&#x2713;" />} if enforce_utf8
    if method && !%w(get post).include?(method.to_s)
      txt << %{<input name="_method" type="hidden" value="#{method}" />}
    end
    txt << %(<input type="hidden" name="authenticity_token" value="#{CSRF_TOKEN}"/>) if csrf_protection
    txt << %{</div>}
  end

end
