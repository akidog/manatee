require_relative '../test_helper'

class FormOptionsTest < JavascriptRenderer::ViewTest

  Post      = Struct.new 'Post',      :title, :author_name, :body, :secret, :written_on, :category, :origin, :allow_comments
  Album     = Struct.new 'Album',     :id, :title, :genre
  Country   = Struct.new 'Country',   :country_id, :country_name
  Continent = Struct.new 'Continent', :continent_name, :countries

  [ Post, Album, Country, Continent ].each do |klass|
    klass.send :define_method, :to_json do |*args|
      hash = Hash[ self.class.members.map{ |key| [key, public_send(key)] } ]
      hash['_class'] = self.class.name.match('::').post_match
      hash.to_json
    end

    klass.send :define_method, :[] do |key|
      begin
        super key
      rescue NameError
        key == 'class' ? self.class.name.match('::').post_match : nil
      end
    end
  end

  def setup
    config_renderer do |config|
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

  # # TODO: I didn't found a nice way to support ranges on optionsForSelect helper
  # def test_range_options_for_select
  #   expected = '<option value="1">1</option><option value="2">2</option><option value="3">3</option>'
  #   assert_dom_helper expected, :optionsForSelect, 1..3
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

  # # TODO: Think about "ducktyped" params on optionsForSelect helper
  # #       Code commented below is a snipped extracted from actionview source code,
  # #       it needs to be modified before any attempt of running it
  # def test_ducktyped_options_for_select
  #   quack = Struct.new(:first, :last)
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option><option value=\"Dollar\">$</option>",
  #     options_for_select([quack.new("<DKR>", "<Kroner>"), quack.new("$", "Dollar")])
  #   )
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option><option value=\"Dollar\" selected=\"selected\">$</option>",
  #     options_for_select([quack.new("<DKR>", "<Kroner>"), quack.new("$", "Dollar")], "Dollar")
  #   )
  #   assert_dom_equal(
  #     "<option value=\"&lt;Kroner&gt;\" selected=\"selected\">&lt;DKR&gt;</option><option value=\"Dollar\" selected=\"selected\">$</option>",
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

  # # TODO: It seems to be impossible to handle "integer floats" on Javascript on optionsFromCollectionForSelect
  #         Those tests below fails because I could not make that 100% Rails-compatible
  # def test_collection_options_with_preselected_value_as_string_and_option_value_is_float
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option><option value="2.0" selected="selected">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: '2.0'
  # end
  #
  # def test_collection_options_with_preselected_value_as_nil
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option><option value="2.0">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', selected: nil
  # end
  #
  # def test_collection_options_with_disabled_value_as_nil
  #   albums = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option><option value="2.0">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', disabled: nil
  # end
  #
  # def test_collection_options_with_disabled_value_as_array
  #   albums = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop') ]
  #   expected = %(<option value="1.0">rap</option><option value="2.0">pop</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', disabled: ['1.0', 2.0]
  # end
  #
  # def test_collection_options_with_preselected_values_as_string_array_and_option_value_is_float
  #   albums   = [ Album.new(1.0, 'first', 'rap'), Album.new(2.0, 'second', 'pop'), Album.new(3.0, 'third', 'country') ]
  #   expected = %(<option value="1.0" selected="selected">rap</option><option value="2.0">pop</option><option value="3.0" selected="selected">country</option>)
  #   assert_dom_helper expected, :optionsFromCollectionForSelect, albums, 'id', 'genre', ['1.0', '3.0']
  # end

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

  def test_select
    post     = Post.new '<mus>'
    expected = '<select id="post_title" name="post[title]"><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, ['post', 'title'], %w( abe <mus> hest)
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, ['post', 'title'], ['abe', '<mus>', 'hest'] )
    assert_dom_helper    expected, :selectForObject, post, 'title' , %w( abe <mus> hest)
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'title', ['abe', '<mus>', 'hest'] )
  end

  def test_select_without_multiple
    post     = Post.new '<mus>'
    expected = '<select id="post_category" name="post[category]"></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, '', multiple: false
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', '', { multiple: false } )
  end


  def test_select_with_grouped_collection_as_nested_array
    countries_by_continent = [
      [ '<Africa>', [ [ '<South Africa>', '<sa>' ], [ 'Somalia', 'so' ] ] ],
      [ 'Europe',   [ [ 'Denmark',        'dk'   ], [ 'Ireland', 'ie' ] ] ]
    ]

    post = Post.new
    expected = [
      %(<select id="post_origin" name="post[origin]"><optgroup label="&lt;Africa&gt;"><option value="&lt;sa&gt;">&lt;South Africa&gt;</option>),
      %(<option value="so">Somalia</option></optgroup><optgroup label="Europe"><option value="dk">Denmark</option>),
      %(<option value="ie">Ireland</option></optgroup></select>)
    ].join
    assert_dom_helper    expected, :selectForObject, post, :origin, countries_by_continent
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'origin', #{ countries_by_continent.to_json } )
  end

  def test_select_with_grouped_collection_as_hash
    countries_by_continent = {
      '<Africa>' => [ [ '<South Africa>', '<sa>' ], [ 'Somalia', 'so' ] ],
      'Europe'   => [ [ 'Denmark',        'dk'   ], [ 'Ireland', 'ie' ] ]
    }

    post = Post.new
    expected = [
      %(<select id="post_origin" name="post[origin]"><optgroup label="&lt;Africa&gt;"><option value="&lt;sa&gt;">&lt;South Africa&gt;</option>),
      %(<option value="so">Somalia</option></optgroup><optgroup label="Europe"><option value="dk">Denmark</option>),
      %(<option value="ie">Ireland</option></optgroup></select>)
    ].join
    assert_dom_helper    expected, :selectForObject, post, :origin, countries_by_continent
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'origin', #{ countries_by_continent.to_json } )
  end

  def test_select_with_boolean_method
    post = Post.new
    post.allow_comments = false

    expected = '<select id="post_allow_comments" name="post[allow_comments]"><option value="true">true</option><option value="false" selected="selected">false</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :allow_comments, [ true, false ]
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'allow_comments', [ true, false ] )
  end

  def test_select_with_multiple_to_add_hidden_input
    post = Post.new
    expected = '<input type="hidden" name="post[category][]" value=""/><select multiple="multiple" id="post_category" name="post[category][]"></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, '', multiple: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', '', { multiple: true } )
  end

  def test_select_with_multiple_and_without_hidden_input
    post = Post.new
    expected = '<select multiple="multiple" id="post_category" name="post[category][]"></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, '', include_hidden: false, multiple: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', '', { include_hidden: false, multiple: true } )
  end

  def test_select_with_multiple_and_with_explicit_name_ending_with_brackets
    post = Post.new
    expected = '<select multiple="multiple" id="post_category" name="post[category][]"></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, '', include_hidden: false, multiple: true, name: 'post[category][]'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', '', { include_hidden: false, multiple: true, name: 'post[category][]' } )
  end

  def test_select_with_multiple_and_disabled_to_add_disabled_hidden_input
    post = Post.new
    expected = '<input disabled="disabled" type="hidden" name="post[category][]" value=""/><select multiple="multiple" disabled="disabled" id="post_category" name="post[category][]"></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, '', multiple: true, disabled: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', '', { multiple: true, disabled: true } )
  end

  def test_select_with_blank
    post = Post.new
    post.category = '<mus>'
    expected = '<select id="post_category" name="post[category]"><option value=""></option><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], include_blank: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { include_blank: true } )
  end

  def test_select_with_blank_as_string
    post = Post.new
    post.category = '<mus>'
    expected = '<select id="post_category" name="post[category]"><option value="">None</option><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], include_blank: 'None'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { include_blank: 'None' } )
  end

  def test_select_with_blank_as_string_escaped
    post = Post.new
    post.category = '<mus>'
    expected = '<select id="post_category" name="post[category]"><option value="">&lt;None&gt;</option><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], include_blank: '<None>'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { include_blank: '<None>' } )
  end

  def test_select_with_default_prompt
    post = Post.new
    post.category = ''
    expected = '<select id="post_category" name="post[category]"><option value="">Please select</option><option value="abe">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], prompt: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { prompt: true } )
  end

  def test_select_no_prompt_when_select_has_value
    post = Post.new
    post.category = '<mus>'
    expected = '<select id="post_category" name="post[category]"><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], prompt: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { prompt: true } )
  end

  def test_select_with_given_prompt
    post = Post.new
    post.category = ''
    expected = '<select id="post_category" name="post[category]"><option value="">The prompt</option><option value="abe">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], prompt: 'The prompt'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { prompt: 'The prompt' } )
  end

  def test_select_with_given_prompt_escaped
    post = Post.new
    post.category = ''
    expected = '<select id="post_category" name="post[category]"><option value="">&lt;The prompt&gt;</option><option value="abe">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], prompt: '<The prompt>'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { prompt: '<The prompt>' } )
  end

  def test_select_with_prompt_and_blank
    post = Post.new
    post.category = ''
    expected = '<select id="post_category" name="post[category]"><option value="">Please select</option><option value=""></option><option value="abe">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], prompt: true, include_blank: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { prompt: true, include_blank: true } )
  end

  def test_empty
    post = Post.new
    post.category = ''
    expected = '<select id="post_category" name="post[category]"><option value="">Please select</option><option value=""></option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, [], prompt: true, include_blank: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', [], { prompt: true, include_blank: true } )
  end

  def test_select_with_nil
    post = Post.new
    post.category = 'othervalue'
    expected = '<select id="post_category" name="post[category]"><option value=""></option><option value="othervalue" selected="selected">othervalue</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, [ nil, 'othervalue' ]
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', [ null, 'othervalue' ] )
  end

  def test_required_select
    post = Post.new
    expected = '<select id="post_category" name="post[category]" required="required"><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], required: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { required: true } )
  end

  def test_required_select_with_include_blank_prompt
    post = Post.new
    expected = '<select id="post_category" name="post[category]" required="required"><option value="">Select one</option><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], include_blank: 'Select one', required: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { include_blank: 'Select one', required: true } )
  end

  def test_required_select_with_prompt
    post = Post.new
    expected = '<select id="post_category" name="post[category]" required="required"><option value="">Select one</option><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], prompt: 'Select one', required: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { prompt: 'Select one', required: true } )
  end

  def test_required_select_display_size_equals_to_one
    post = Post.new
    expected = '<select id="post_category" name="post[category]" required="required" size="1"><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], required: true, size: 1
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { required: true, size: 1 } )
  end

  def test_required_select_with_display_size_bigger_than_one
    post = Post.new
    expected = '<select id="post_category" name="post[category]" required="required" size="2"><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], required: true, size: 2
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { required: true, size: 2 } )
  end

  def test_required_select_with_multiple_option
    post = Post.new
    expected = '<input name="post[category][]" type="hidden" value=""/><select id="post_category" multiple="multiple" name="post[category][]" required="required"><option value="abe">abe</option><option value="mus">mus</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', 'mus', 'hest'], required: true, multiple: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', 'mus', 'hest'], { required: true, multiple: true } )
  end

  def test_select_with_fixnum
    post = Post.new
    expected = '<select id="post_category" name="post[category]"><option value="">Please select</option><option value=""></option><option value="1">1</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, [1], prompt: true, include_blank: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', [1], { prompt: true, include_blank: true } )
  end

  def test_list_of_lists
    post = Post.new
    expected = '<select id="post_category" name="post[category]"><option value="">Please select</option><option value=""></option><option value="1">1</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, [1], prompt: true, include_blank: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', [1], { prompt: true, include_blank: true } )
  end

  def test_select_not_escapes_string_content
    post = Post.new
    expected = '<select id="post_title" name="post[title]"><script>alert(1)</script></select>'
    assert_dom_helper    expected, :selectForObject, post, 'title', '<script>alert(1)</script>'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'title', '<script>alert(1)</script>' )
  end

  def test_select_with_blocks
    post = Post.new
    expected = '<select id="post_title" name="post[title]"><option value="some_value">Some Option</option></select>'
    assert_dom_helper(   expected, :selectForObject, post, 'title'){ '<option value="some_value">Some Option</option>' }
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'title', function(){ return '<option value="some_value">Some Option</option>'; } )
  end


  def test_select_with_selected_value
    post = Post.new
    expected = '<select id="post_category" name="post[category]"><option value="abe" selected="selected">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, :category, ['abe', '<mus>', 'hest'], selected: 'abe'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { selected: 'abe' } )
  end

  def test_select_with_selected_nil
    post = Post.new
    post.category = '<mus>'
    expected = '<select id="post_category" name="post[category]"><option value="abe">abe</option><option value="&lt;mus&gt;">&lt;mus&gt;</option><option value="hest">hest</option></select>'
    assert_dom_helper    expected, :selectForObject, post, 'category', ['abe', '<mus>', 'hest'], selected: nil
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { selected: null } )
  end

  def test_select_not_existing_method_with_selected_value
    post = Post.new
    expected = '<select id="post_locale" name="post[locale]"><option value="en">en</option><option value="ru" selected="selected">ru</option></select>'
    assert_dom_helper    expected, :selectForObject, post, 'locale', ['en', 'ru'], selected: 'ru'
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'locale', ['en', 'ru'], { selected: 'ru' } )
  end

  def test_select_with_prompt_and_selected_value
    post = Post.new
    expected = '<select id="post_category" name="post[category]"><option value="one">one</option><option selected="selected" value="two">two</option></select>'
    assert_dom_helper    expected, :selectForObject, post, 'category', ['one', 'two'], selected: 'two', prompt: true
    assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['one', 'two'], { selected: 'two', prompt: true } )
  end

  # # TODO: Think about not handle disabled option on selectForObject helper
  # def test_select_with_disabled_value
  #   post = Post.new
  #   post.category = '<mus>'
  #   expected = '<select id="post_category" name="post[category]"><option value="abe">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest" disabled="disabled">hest</option></select>'
  #   assert_dom_helper    expected, :selectForObject, post, 'category', ['abe', '<mus>', 'hest'], disabled: 'hest'
  #   assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { disabled: 'hest' } )
  # end
  #
  # def test_select_with_disabled_array
  #   post = Post.new
  #   expected = '<select id="post_category" name="post[category]"><option value="abe" disabled="disabled">abe</option><option value="&lt;mus&gt;" selected="selected">&lt;mus&gt;</option><option value="hest" disabled="disabled">hest</option></select>'
  #   assert_dom_helper    expected, :selectForObject, post, 'category', ['abe', '<mus>', 'hest'], disabled: [ 'hest', 'abe' ]
  #   assert_dom_js_helper expected, :selectForObject, %( #{ post.to_json }, 'category', ['abe', '<mus>', 'hest'], { disabled: [ 'hest', 'abe' ] } )
  # end

  # # TODO: I didn't found a nice way to support ranges on selectForObject helper
  # def test_select_with_range
  #   post = Post.new
  #   post.category = 0
  #   expected = '<select id="post_category" name="post[category]"><option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option></select>'
  #   assert_dom_helper expected, :selectForObject, post, 'category', 1..3
  # end

  def test_collection_select
    post = Post.new
    post.author_name = 'Babe'
    expected = '<select id="post_author_name" name="post[author_name]"><option value="&lt;Abe&gt;">&lt;Abe&gt;</option><option value="Babe" selected="selected">Babe</option><option value="Cabe">Cabe</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name
  end

  def test_collection_select_with_blank_and_style
    post = Post.new
    post.author_name = 'Babe'
    expected = '<select id="post_author_name" name="post[author_name]" style="width: 200px"><option value=""></option><option value="&lt;Abe&gt;">&lt;Abe&gt;</option><option value="Babe" selected="selected">Babe</option><option value="Cabe">Cabe</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name, include_blank: true, style: 'width: 200px'
  end

  def test_collection_select_with_blank_as_string_and_style
    post = Post.new
    post.author_name = 'Babe'
    expected = '<select id="post_author_name" name="post[author_name]" style="width: 200px"><option value="">No Selection</option><option value="&lt;Abe&gt;">&lt;Abe&gt;</option><option value="Babe" selected="selected">Babe</option><option value="Cabe">Cabe</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name, include_blank: 'No Selection', style: 'width: 200px'
  end

  def test_collection_select_with_multiple_option_appends_array_brackets_and_hidden_input
    post = Post.new
    post.author_name = 'Babe'
    expected = '<input type="hidden" name="post[author_name][]" value=""/><select id="post_author_name" name="post[author_name][]" multiple="multiple"><option value=""></option><option value="&lt;Abe&gt;">&lt;Abe&gt;</option><option value="Babe" selected="selected">Babe</option><option value="Cabe">Cabe</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name, include_blank: true, multiple: true
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name, include_blank: true, multiple: true, name: 'post[author_name][]'
  end

  def test_collection_select_with_blank_and_selected
    post = Post.new
    post.author_name = 'Babe'
    expected = '<select id="post_author_name" name="post[author_name]"><option value=""></option><option value="&lt;Abe&gt;" selected="selected">&lt;Abe&gt;</option><option value="Babe">Babe</option><option value="Cabe">Cabe</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, :author_name, :author_name, include_blank: true, selected: '<Abe>'
  end

  def test_collection_select_with_proc_for_value_method
    post = Post.new
    expected = '<select id="post_author_name" name="post[author_name]"><option value="&lt;Abe&gt;">&lt;Abe&gt; went home</option><option value="Babe">Babe went home</option><option value="Cabe">Cabe went home</option></select>'
    assert_dom_helper expected, :collectionSelectForObject, post, :author_name, dummy_posts, lambda{ |jr, post| post.author_name }, :title
  end

  # def test_collection_select_with_proc_for_text_method
  #   @post = Post.new
  #
  #   assert_dom_equal(
  #     "<select id=\"post_author_name\" name=\"post[author_name]\"><option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option></select>",
  #     collection_select("post", "author_name", dummy_posts, "author_name", lambda { |p| p.title })
  #   )
  # end

  # # TODO: Think about not handle disabled option on collectionSelectForObject helper
  # def test_collection_select_with_disabled
  #   @post = Post.new
  #   @post.author_name = "Babe"
  #
  #   assert_dom_equal(
  #     "<select id=\"post_author_name\" name=\"post[author_name]\"><option value=\"&lt;Abe&gt;\">&lt;Abe&gt;</option>\n<option value=\"Babe\" selected=\"selected\">Babe</option>\n<option value=\"Cabe\" disabled=\"disabled\">Cabe</option></select>",
  #     collection_select("post", "author_name", dummy_posts, "author_name", "author_name", :disabled => 'Cabe')
  #   )
  # end

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
