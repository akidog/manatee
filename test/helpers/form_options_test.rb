require_relative '../test_helper'

class FormOptionsTest < JavascriptRenderer::ViewTest

  def setup
    reset_renderer do |config|
      config.fonts_path      = '/fonts'
      config.audios_path     = '/audios'
      config.videos_path     = '/videos'
      config.images_path     = '/images'
      config.javascript_path = ''
      config.stylesheet_path = ''
    end
  end

  def test_string_options_for_select
    options = '<option value="Denmark">Denmark</option><option value="USA">USA</option><option value="Sweden">Sweden</option>'
    assert_dom_helper options, :optionsForSelect, options
  end

  def test_array_options_for_select
    expected = '<option value="&lt;Denmark&gt;">&lt;Denmark&gt;</option><option value="USA">USA</option><option value="Sweden">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ '<Denmark>', 'USA', 'Sweden' ]
  end

  def test_array_options_for_select_with_custom_defined_selected
    options = [
      ['Richard Bandler', 1, { type: 'Coach', selected: 'selected' } ],
      ['Richard Bandler', 1, { type: 'Coachee'                     } ]
    ]
    expected = '<option selected="selected" type="Coach" value="1">Richard Bandler</option><option type="Coachee" value="1">Richard Bandler</option>'
    assert_dom_helper expected, :optionsForSelect, options

    options = [
      ['Richard Bandler', 1, { type: 'Coach', selected: true } ],
      ['Richard Bandler', 1, { type: 'Coachee'               } ]
    ]
    assert_dom_helper expected, :optionsForSelect, options
  end

  def test_array_options_for_select_with_custom_defined_disabled
    options = [
      ['Richard Bandler', 1, { type: 'Coach', disabled: 'disabled' } ],
      ['Richard Bandler', 1, { type: 'Coachee'                     } ]
    ]
    expected = '<option disabled="disabled" type="Coach" value="1">Richard Bandler</option><option type="Coachee" value="1">Richard Bandler</option>'
    assert_dom_helper expected, :optionsForSelect, options

    options = [
      ['Richard Bandler', 1, { type: 'Coach', disabled: true } ],
      ['Richard Bandler', 1, { type: 'Coachee'               } ]
    ]
    assert_dom_helper expected, :optionsForSelect, options
  end

  def test_array_options_for_select_with_selection
    expected = '<option value="Denmark">Denmark</option><option value="&lt;USA&gt;" selected="selected">&lt;USA&gt;</option><option value="Sweden">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'Denmark', '<USA>', 'Sweden' ], '<USA>'
  end

  def test_array_options_for_select_with_selection_array
    expected = '<option value="Denmark">Denmark</option><option value="&lt;USA&gt;" selected="selected">&lt;USA&gt;</option><option value="Sweden" selected="selected">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, ['Denmark', '<USA>', 'Sweden'], ['<USA>', 'Sweden']
  end

  def test_array_options_for_select_with_disabled_value
    expected = '<option value="Denmark">Denmark</option><option value="&lt;USA&gt;" disabled="disabled">&lt;USA&gt;</option><option value="Sweden">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'Denmark', '<USA>', 'Sweden' ], disabled: '<USA>'
  end

  def test_array_options_for_select_with_disabled_array
    expected = '<option value="Denmark">Denmark</option><option value="&lt;USA&gt;" disabled="disabled">&lt;USA&gt;</option><option value="Sweden" disabled="disabled">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'Denmark', '<USA>', 'Sweden' ], disabled: ['<USA>', 'Sweden']
  end

  def test_array_options_for_select_with_selection_and_disabled_value
    expected = '<option value="Denmark" selected="selected">Denmark</option><option value="&lt;USA&gt;" disabled="disabled">&lt;USA&gt;</option><option value="Sweden">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'Denmark', '<USA>', 'Sweden' ], selected: 'Denmark', disabled: '<USA>'
  end

  def test_boolean_array_options_for_select_with_selection_and_disabled_value
    expected = '<option value="true">true</option><option value="false" selected="selected">false</option>'
    assert_dom_helper expected, :optionsForSelect, [ true, false ], selected: false, disabled: nil
  end

  # def test_range_options_for_select
  #   assert_dom_equal(
  #     "<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option value=\"3\">3</option>",
  #     options_for_select(1..3)
  #   )
  # end

  def test_array_options_for_string_include_in_other_string_bug_fix
    expected = '<option value="ruby">ruby</option><option value="rubyonrails" selected="selected">rubyonrails</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'ruby', 'rubyonrails' ], 'rubyonrails'

    expected = '<option value="ruby" selected="selected">ruby</option><option value="rubyonrails">rubyonrails</option>'
    assert_dom_helper expected, :optionsForSelect, [ 'ruby', 'rubyonrails' ], 'ruby'

    expected = '<option value="ruby" selected="selected">ruby</option><option value="rubyonrails">rubyonrails</option><option value=""></option>'
    assert_dom_helper expected, :optionsForSelect, [ 'ruby', 'rubyonrails', nil ], 'ruby'
  end

  def test_hash_options_for_select_should_behave_like_array_options
    expected = '<option value="Dollar">$</option><option value="&lt;Kroner&gt;">&lt;DKR&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ ['$', 'Dollar'], ['<DKR>', '<Kroner>'] ]
    assert_dom_helper expected, :optionsForSelect, '$' => 'Dollar', '<DKR>' => '<Kroner>'

    expected = '<option value="Dollar" selected="selected">$</option><option value="&lt;Kroner&gt;">&lt;DKR&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ ['$', 'Dollar'], ['<DKR>', '<Kroner>'] ], 'Dollar'
    assert_dom_helper expected, :optionsForSelect, { '$' => 'Dollar', '<DKR>' => '<Kroner>' }, 'Dollar'

    expected = '<option value="Dollar" selected="selected">$</option><option value="&lt;Kroner&gt;" selected="selected">&lt;DKR&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ ['$', 'Dollar'], ['<DKR>', '<Kroner>'] ], [ 'Dollar', '<Kroner>' ]
    assert_dom_helper expected, :optionsForSelect, { '$' => 'Dollar', '<DKR>' => '<Kroner>' }, [ 'Dollar', '<Kroner>' ]
  end

  # def test_ducktyped_options_for_select
  #   quack = Struct.new(:first, :last)
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option>\n<option value=\"Dollar\">$</option>",
  #     options_for_select([quack.new("<DKR>", "<Kroner>"), quack.new("$", "Dollar")])
  #   )
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option>\n<option value=\"Dollar\" selected=\"selected\">$</option>",
  #     options_for_select([quack.new("<DKR>", "<Kroner>"), quack.new("$", "Dollar")], "Dollar")
  #   )
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\" selected=\"selected\">&lt;DKR&gt;</option>\n<option value=\"Dollar\" selected=\"selected\">$</option>",
  #     options_for_select([quack.new("<DKR>", "<Kroner>"), quack.new("$", "Dollar")], ["Dollar", "<Kroner>"])
  #   )
  # end

  def test_options_for_select_with_element_attributes
    expected = '<option value="&lt;Denmark&gt;" class="bold">&lt;Denmark&gt;</option><option value="USA" onclick="alert(&#39;Hello World&#39;);">USA</option><option value="Sweden">Sweden</option><option value="Germany">Germany</option>'
    assert_dom_helper expected, :optionsForSelect, [ [ '<Denmark>', { class: 'bold' } ], [ 'USA', { onclick: "alert('Hello World');" } ], [ 'Sweden' ], 'Germany' ]
  end

  def test_options_for_select_with_data_element
    expected = '<option value="&lt;Denmark&gt;" data-test="bold">&lt;Denmark&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ [ "<Denmark>", { data: { test: 'bold' } } ] ]
  end

  def test_options_for_select_with_data_element_with_special_characters
    expected = '<option value="&lt;Denmark&gt;" data-test="&lt;bold&gt;">&lt;Denmark&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ [ "<Denmark>", { data: { test: '<bold>' } } ] ]
  end

  def test_options_for_select_with_element_attributes_and_selection
    expected = '<option value="&lt;Denmark&gt;">&lt;Denmark&gt;</option><option value="USA" class="bold" selected="selected">USA</option><option value="Sweden">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ '<Denmark>', [ 'USA', { class: 'bold' } ], 'Sweden' ], 'USA'
  end

  def test_options_for_select_with_element_attributes_and_selection_array
    expected = '<option value="&lt;Denmark&gt;">&lt;Denmark&gt;</option><option value="USA" class="bold" selected="selected">USA</option><option value="Sweden" selected="selected">Sweden</option>'
    assert_dom_helper expected, :optionsForSelect, [ '<Denmark>', [ 'USA', { class: 'bold' } ], 'Sweden' ], [ 'USA', 'Sweden' ]
  end

  def test_options_for_select_with_special_characters
    expected = '<option value="&lt;Denmark&gt;" onclick="alert(&quot;&lt;code&gt;&quot;)">&lt;Denmark&gt;</option>'
    assert_dom_helper expected, :optionsForSelect, [ [ '<Denmark>', { onclick: %(alert("<code>")) } ] ]
  end

end
