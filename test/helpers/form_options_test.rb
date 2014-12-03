require_relative '../test_helper'

class FormOptionsTest < JavascriptRenderer::ViewTest

  Post      = Struct.new 'Post',      :title, :author_name, :body, :secret, :written_on, :category, :origin, :allow_comments
  Album     = Struct.new 'Album',     :id, :title, :genre
  Country   = Struct.new 'Country',   :country_id, :country_name
  Continent = Struct.new 'Continent', :continent_name, :countries

  [ Post, Album, Country, Continent ].each do |klass|
    klass.send :define_method, :to_json do |*args|
      Hash[ self.class.members.map{ |key| [key, public_send(key)] } ].to_json
    end
  end

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

  def test_collection_options
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title'
  end

  def test_collection_options_with_preselected_value
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" selected="selected">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', 'Babe'
  end

  def test_collection_options_with_preselected_value_array
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" selected="selected">Babe went home</option><option value="Cabe" selected="selected">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', [ 'Babe', 'Cabe' ]
  end

  def test_collection_options_with_proc_for_selected
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" selected="selected">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper    expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', lambda{ |jr, post| post.author_name == 'Babe' }
    assert_dom_js_helper expected, :optionsFromCollectionForSelect, %( #{ dummy_posts.to_json }, 'author_name', 'title', function(post){ return post.author_name == 'Babe'; } )
  end

  def test_collection_options_with_disabled_value
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" disabled="disabled">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', disabled: 'Babe'
  end

  def test_collection_options_with_disabled_array
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" disabled="disabled">Babe went home</option><option value="Cabe" disabled="disabled">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', disabled: [ 'Babe', 'Cabe' ]
  end

  def test_collection_options_with_preselected_and_disabled_value
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" disabled="disabled">Babe went home</option><option value="Cabe" selected="selected">Cabe went home</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', selected: 'Cabe', disabled: 'Babe'
  end

  def test_collection_options_with_proc_for_disabled
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe" disabled="disabled">Babe went home</option><option value="Cabe" disabled="disabled">Cabe went home</option>'
    assert_dom_helper    expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', 'title', disabled: lambda { |jr, post| %w(Babe Cabe).include? post.author_name }
    assert_dom_js_helper expected, :optionsFromCollectionForSelect, %( #{ dummy_posts.to_json }, 'author_name', 'title', { disabled: function(post){ return ['Babe', 'Cabe'].indexOf(post.author_name) > -1; } } )
  end

  def test_collection_options_with_proc_for_value_method
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper    expected, :optionsFromCollectionForSelect, dummy_posts, lambda{ |jr, post| post.author_name }, 'title'
    assert_dom_js_helper expected, :optionsFromCollectionForSelect, %( #{ dummy_posts.to_json }, function(post){ return post.author_name; }, 'title' )
  end

  def test_collection_options_with_proc_for_text_method
    expected = '<option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe">Babe went home</option><option value="Cabe">Cabe went home</option>'
    assert_dom_helper    expected, :optionsFromCollectionForSelect, dummy_posts, 'author_name', lambda { |jr, post| post.title }
    assert_dom_js_helper expected, :optionsFromCollectionForSelect, %( #{ dummy_posts.to_json }, 'author_name', function(post){ return post.title; } )
  end

  def test_collection_options_with_element_attributes
    expected = '<option value="USA" class="bold">USA</option>'
    assert_dom_helper expected, :optionsFromCollectionForSelect, [ [ 'USA', 'USA', { class: 'bold' } ] ], 0, 1
  end

  def test_collection_options_with_preselected_value_as_string_and_option_value_is_integer
    albums   = [ Album.new(1, 'first', 'rap'), Album.new(2, 'second', 'pop') ]
    expected = %(<option selected="selected" value="1">rap</option><option value="2">pop</option>)
    assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: '1'
  end

  def test_collection_options_with_preselected_value_as_integer_and_option_value_is_string
    albums   = [ Album.new('1', 'first', 'rap'), Album.new('2', 'second', 'pop') ]
    expected = %(<option selected="selected" value="1">rap</option><option value="2">pop</option>)
    assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: 1
  end

  # TODO: It seems to be impossible to handle "integer floats" on Javascript
  # def test_collection_options_with_preselected_value_as_string_and_option_value_is_float
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option><option value="2.0" selected="selected">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: '2.0'
  # end
  #
  # def test_collection_options_with_preselected_value_as_nil
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option>\n<option value="2.0">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: nil
  # end
  #
  # def test_collection_options_with_disabled_value_as_nil
  #   albums = [ Album.new(1.0, "first","rap"), Album.new(2.0, "second","pop")]
  #
  #   assert_dom_equal(
  #   %(<option value="1.0">rap</option>\n<option value="2.0">pop</option>),
  #   options_from_collection_for_select(albums, "id", "genre", :disabled => nil)
  #   )
  # end
  #
  # def test_collection_options_with_disabled_value_as_array
  #   albums = [ Album.new(1.0, "first","rap"), Album.new(2.0, "second","pop")]
  #
  #   assert_dom_equal(
  #   %(<option disabled="disabled" value="1.0">rap</option>\n<option disabled="disabled" value="2.0">pop</option>),
  #   options_from_collection_for_select(albums, "id", "genre", :disabled => ["1.0", 2.0])
  #   )
  # end
  #
  # def test_collection_options_with_preselected_values_as_string_array_and_option_value_is_float
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop'), Album.new(3.0, 'third', 'country') ]
  #   expected = %(<option value="1.0" selected="selected">rap</option><option value="2.0">pop</option><option value="3.0" selected="selected">country</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', ['1.0', '3.0']
  # end

  # grouped_options_for_select

  def test_grouped_options_for_select_with_array
    options = [
      [ 'North America',
        [ [ 'United States', 'US' ], 'Canada' ]
      ],
      [ 'Europe',
        [ [ 'Great Britain', 'GB' ], 'Germany' ]
      ]
    ]
    expected = %(<optgroup label="North America"><option value="US">United States</option><option value="Canada">Canada</option></optgroup><optgroup label="Europe"><option value="GB">Great Britain</option><option value="Germany">Germany</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, options
  end

  def test_grouped_options_for_select_with_array_and_html_attributes
    options = [
      [ 'North America',
        [ [ 'United States', 'US'], 'Canada' ], data: { foo: 'bar' }
      ],
      [ 'Europe',
        [ [ 'Great Britain', 'GB'], 'Germany' ], disabled: 'disabled'
      ]
    ]
    expected = %(<optgroup label="North America" data-foo="bar"><option value="US">United States</option><option value="Canada">Canada</option></optgroup><optgroup label="Europe" disabled="disabled"><option value="GB">Great Britain</option><option value="Germany">Germany</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, options
  end

  def test_grouped_options_for_select_with_optional_divider
    expected = %(<optgroup label="----------"><option value="US">US</option><option value="Canada">Canada</option></optgroup><optgroup label="----------"><option value="GB">GB</option><option value="Germany">Germany</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, [ [ 'US', 'Canada' ] , [ 'GB', 'Germany' ] ], nil, divider: '----------'
  end

  def test_grouped_options_for_select_with_selected_and_prompt
    expected = %(<option value="">Choose a product...</option><optgroup label="Hats"><option value="Baseball Cap">Baseball Cap</option><option selected="selected" value="Cowboy Hat">Cowboy Hat</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, [ ['Hats', [ 'Baseball Cap', 'Cowboy Hat' ] ] ], 'Cowboy Hat', prompt: 'Choose a product...'
  end

  def test_grouped_options_for_select_with_selected_and_prompt_true
    expected = %(<option value="">Please select</option><optgroup label="Hats"><option value="Baseball Cap">Baseball Cap</option><option selected="selected" value="Cowboy Hat">Cowboy Hat</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, [ ['Hats', [ 'Baseball Cap', 'Cowboy Hat' ] ] ], 'Cowboy Hat', prompt: true
  end

  def test_grouped_options_for_select_with_prompt_returns_html_escaped_string
    expected = %(<option value="">&lt;Choose One&gt;</option><optgroup label="Hats"><option value="Baseball Cap">Baseball Cap</option><option value="Cowboy Hat">Cowboy Hat</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, [ ['Hats', [ 'Baseball Cap', 'Cowboy Hat' ] ] ], nil, prompt: '<Choose One>'
  end

  def test_optgroups_with_with_options_with_hash
    options = {
      'North America' => [ 'United States', 'Canada'  ],
      'Europe'        => [ 'Denmark',       'Germany' ]
    }
    expected = %(<optgroup label="North America"><option value="United States">United States</option><option value="Canada">Canada</option></optgroup><optgroup label="Europe"><option value="Denmark">Denmark</option><option value="Germany">Germany</option></optgroup>)
    assert_dom_helper expected, :groupedOptionsForSelect, options
  end

  def test_option_groups_from_collection_for_select
    expected = %(<optgroup label="&lt;Africa&gt;"><option value="&lt;sa&gt;">&lt;South Africa&gt;</option><option value="so">Somalia</option></optgroup><optgroup label="Europe"><option value="dk" selected="selected">Denmark</option><option value="ie">Ireland</option></optgroup>)
    assert_dom_helper expected, :optionGroupsFromCollectionForSelect, dummy_continents, 'countries', 'continent_name', 'country_id', 'country_name', 'dk'
  end

  protected
  def dummy_posts
    [
      Post.new('<Abe> went home', '<Abe>', 'To a little house', 'shh!'),
      Post.new('Babe went home',  'Babe',  'To a little house', 'shh!'),
      Post.new('Cabe went home',  'Cabe',  'To a little house', 'shh!')
    ]
  end

  def dummy_continents
    [
      Continent.new('<Africa>', [ Country.new('<sa>', '<South Africa>'), Country.new('so', 'Somalia') ]),
      Continent.new('Europe',   [ Country.new('dk', 'Denmark'),          Country.new('ie', 'Ireland') ])
    ]
  end

end
