//
// StartPage
// ----------
// description: Lightweight, minimalistic startpage
// license: MIT
// author:  Andrew Lo <http://github.com/abstractOwl>
//

(function () {
  'use strict';

  // Set default links
  var defaultData = [
    {
      'name': 'hello',
      'links': [
        {
          'name': 'google',
          'url': "http://www.google.com",
        }, {
          'name': 'identi.ca',
          'url': 'http://www.identi.ca'
        }
      ]
    }, {
      'name': 'goodbye',
      'links':  [
        {
          'name': 'test',
          'url': 'http://b.com'
        }
      ]
    }
  ];

  // Represent URL category
  function Category(name) {
    this.children  =  {};
    this.name    =  name;
    this.count    =  0;
  }
  // Mold it into any shape you want! Perfect gift for any childNode.
  Category.prototype.htmlDoh =
    '<li class="category"><div><span>{{name}}</span></div>'
    + '<ul>{{links}}{{addLink}}'
    + '</ul></li>';
  Category.prototype.stringDoh =
    '{ "name": "{{name}}", "links": [{{links}}] }';
  // Add a Link object to this Category
  Category.prototype.add = function (name, url) {
    this.children[this.count] = new Link(name, url, this.count);
    this.count++;
  };
  Category.prototype.get = function (idx) {
    return this.children[idx];
  };
  // Given an id, remove Link associated with that id
  Category.prototype.remove = function (id) {
    delete this.children[id];
  };
  // Get element representation of this Category instance
  Category.prototype.toElement = function () {
    return magic(this.html());
  };
  // Get HTML representation of this Category instance
  Category.prototype.html = function () {
    var s = '';

    for (var p in this.children) {
      s += this.children[p].html();
    }

    return (
      compile(this.htmlDoh, {
        name: this.name,
        links: s
      })
    );
  };
  // Can't use .length because we're using an object, not an array
  Category.prototype.size = function () {
    var c = 0;
    for (var n in this.children) {
      c++;
    }
    return c;
  };
  // Get JSON string representation of thie Category instance
  Category.prototype.toJSON = function () {
    var a = [];

    for (var p in this.children) {
      if (this.children.hasOwnProperty(p)) {
        a.push(this.children[p].toJSON());
      }
    }

    return (
      compile(this.stringDoh, {
        name: this.name,
        links: a.join(', ')
      })
    );
  };

  // Represent Link object
  function Link(name, url, id) {
    this.name  =  name;
    this.url  =  url;
    this.id    =  id;
  }
  // Mold it into any shape you want! Perfect gift for any childNode.
  Link.prototype.htmlDoh    =  '<li>'
    + '<a class="link" data-id="{{id}}" href="{{url}}">{{name}}</a></li>';
  Link.prototype.stringDoh  =  '{ "name": "{{name}}", "url": "{{url}}" }';
  // Get element representation of this Link instance
  Link.prototype.toElement = function () {
    return magic(this.html());
  };
  // Get HTML representation of this Link instance
  Link.prototype.html = function () {
    return (
      compile(this.htmlDoh, {
        id: this.id,
        name: this.name,
        url: this.url
      })
    );
  };
  // Get JSON string representation of this Link instance
  Link.prototype.toJSON = function () {
    return compile(this.stringDoh, { name: this.name, url: this.url });
  };

  // Singleton object representing StartPage application
  var StartPage = (function () {
    var isAddingCategory,
        isAddingLink,
        instance,
        categories,
        element,
        position,
        storage,
        storageImplementations,
        tmpl;

    isAddingCategory = !!0; // Whether to render "add category" block
    isAddingLink     = !!0; // Whether to render "add link" block

    //
    //  Storage Strategies: (cookie|dom|none)
    //    Each storage strategy implements the following functions:
    //      - init(): Initializes storage strategy
    //      - get(k): Retrieves item from storage
    //      - set(k, v): Puts item into storage
    //      - supported(): Check whether browser supports strategy
    //
    storageImplementations = {
      cookie: {
        init: function () {},
        get: function (k) {
          return
            unescape(document.cookie.replace(
              new RegExp("(?:^|.*;\\s*)"
                + escape(sKey).replace(/[\-\.\+\*]/g, "\\$&")
                + "\\s*\\=\\s*((?:[^;](?!;))*[^;]?).*"),
                "$1"
              )
            );
        },
        set: function (k, v) {
          // Only stores one item. Which is all we need, for now
          document.cookie = escape(k) + '=' + escape(v) + '; '
            + 'expires=Tue, 19 Jan 2038 03:14:07 GMT; path=/';
        },
        supported: function () {
          return navigator.cookieEnabled;
        }
      },
      dom: {
        init: function () {},
        get: function (k) {
          return window.localStorage.getItem(k);
        },
        set: function (k, v) {
          window.localStorage.setItem(k, v);
        },
        supported: function () {
          return !!window.localStorage;
        }
      },
      none: {
        init: function () {
          window.alert('DOM and Cookie storage are not supported by '
            + 'your browser. Your session will not be saved.');
        },
        get: function (k) {},
        set: function (k, v) {},
        supported: function () {
          return true;
        }
      }
    };

    // Templates for fake "add" elements
    tmpl = {};
    tmpl.input   = '<input type="text" placeholder="{{placeholder}}">';
    tmpl.addLink = {
      active: compile(Link.prototype.htmlDoh, {
        id: -1,
        url: '#',
        name: 'add link<br />'
            + compile(tmpl.input, { placeholder: 'title' }) + '<br />'
            + compile(tmpl.input, { placeholder: 'url' })
      }),
      inactive: ''
    };
    tmpl.addCategory = {
      active: compile(Category.prototype.htmlDoh, {
        addLink: '',
        links: '',
        name: compile(tmpl.input, { placeholder: 'name' })
      }),
      inactive: ''
    };

    // Append a Link object to the current Category
    function addLink() {
      if (position.x >= 0) {
        var title, url;
        // Don't prompt for URL if title prompt cancelled
        (title  =  prompt ('What will you name this link?')) &&
        (url  =  prompt ('What is the link\'s URL?', 'http://'));

        // Add to current category
        if (title && url) {
          categories[position.x].add(title, url);
          return true;
        }
      }
      return false;
    }

    var VK = {
      ESCAPE: 27,
      UP:     38,
      DOWN:   40,
      LEFT:   37,
      RIGHT:  39,
      ENTER:  13,
      DELETE: 46,

      H: 72,
      J: 74,
      K: 75,
      L: 76
    };

    // Handle keypresses
    function handleKey(key) {
      if (isAddingCategory || isAddingLink) return;
      switch (key) {
      case VK.UP:
      case VK.K:
        if (position.x >= 0) {
          position.y = Math.max(-1, position.y - 1);
          isAddingLink = !!0;
        }
        break;

      case VK.DOWN:
      case VK.J:
        if (position.x >= 0) {
          if (position.y + 1 > categories[position.x].size() - 1) {
            position.y = Math.min(categories[position.x].size(),
              position.y + 1);
            isAddingLink = true;
          } else {
            position.y = Math.min(categories[position.x].size() - 1,
              position.y + 1);
          }
        }
        break;
      case VK.LEFT:
      case VK.H:
        position.x = Math.max(-1, position.x - 1);
        position.y = -1;
        isAddingLink = !!0;
        break;

      case VK.RIGHT:
      case VK.L:
        if (position.x > categories.length - 2) {
          position.x = Math.min(categories.length, position.x + 1);
          isAddingCategory = true;
        } else if (position.x < categories.length) {
          position.x = Math.min(categories.length - 1, position.x + 1);
        } else { return }
        position.y = -1;
        isAddingLink = !!0;
        break;

      case VK.ENTER:
        if (position.x >= 0 && position.y >= 0) {
          location.href = categories[position.x].get(position.y).url;
        }
        break;

      case VK.DELETE:
        if (position.y >= 0) {
          var  currCategory =
            document.getElementsByClassName('category')[position.x],
            currLink =
            currCategory.getElementsByClassName('link')[position.y];
          categories[position.x].remove(
            currLink.getAttribute('data-id')
          );
        } else if (position.x >= 0) {
          // Delete Category
          categories.splice(position.x, 1);
          position.x--;
        }
        break;
      default:
        return; // Don't save/render if nothing happened
      }

      save();
      render();
    }

    // Initialize app
    function init() {
      categories  =  [];

      position = {
        x: -1,
        y: -1
      };

      // Find supported storageImpl
      if (storageImplementations.dom.supported()) {
        storage = storageImplementations.dom;
      } else if (storageImplementations.cookie.supported()) {
        storage = storageImplementations.cookie;
      } else {
        storage = storageImplementations.none;
      }

      window.onkeydown = function (e) {
        var key = e.which ? e.which : e.keyCode;
        handleKey(key);
      };

      return {
        // Load settings or defaults
        loadSettings: function () {
          if (!storage.get('data')) {
            this.fromJSON(JSON.stringify(defaultData));
          } else {
            this.fromJSON(storage.get('data'));
          }

          render();
        },
        // Public functions
        toElement: function () {
          return element;
        },
        fromJSON: function (json) {
          fromJSON(json);
        },
        toJSON: function () {
          return toJSON();
        }
      }
    }
    // Load JSON string into StartPage
    function fromJSON (s) {
      var tmp = JSON.parse(s);
      categories = [];

      // Unwrap JSON object
      for (var i = 0, j = tmp.length; i < j; i++) {
        var c = new Category(tmp[i].name);

        for (var p = 0, q = tmp[i].links, r = q.length; p < r; p++) {
          c.add(q[p].name, q[p].url);
        }

        categories.push(c);
      }
    }
    // Get JSON string representation of StartPage data
    function toJSON() {
      var a = [];

      for (var i = 0, j = categories.length; i < j; i++) {
        a.push(categories[i].toJSON());
      }

      return '[' + a.join(', ') + ']';
    }
    function render() {
      // Definitely not most efficient way of rendering har har
      var clearfix = magic('<div class="clearfix"></div>');

      element = magic('<ul class="container main"></ul>');

      // Build interface
      for (var i = 0, j = categories.length; i < j; i++) {
        var categoryHtml = compile(categories[i].html(), {
          addLink: tmpl.addLink[ (i == position.x && isAddingLink)
            ? 'active' : 'inactive' ]
        });
        var category = magic(categoryHtml);
        if (i == position.x && isAddingLink) {
          var q = category.getElementsByTagName('input');
          q[0].autofocus = true;
          q[1].className += ' url';
          q[1].value = 'http://';

          q[0].onkeydown = q[1].onkeypress = function (e) {
            if (e.which == VK.ENTER && q[0].value && q[1].value) {
              categories[position.x].add(q[0].value, q[1].value);
              isAddingLink = !!0;
              render();
            } else if (e.which == VK.ESCAPE) {
              isAddingLink = !!0;
              position.y--;
              render();
            }
          }
        }
        element.appendChild(category);
      }
      if (isAddingCategory) {
        var categoryPrompt = magic(tmpl.addCategory.active);
        var promptField = categoryPrompt.getElementsByTagName('input')[0];

        categoryPrompt.className += ' active';

        var resetPrompt = function () { isAddingCategory = !!0; render(); };

        promptField.onblur = function () {
          if (promptField.value) {
            categories.push(new Category(promptField.value));
          } else {
            position.x--;
          }
          resetPrompt();
        }
        categoryPrompt.onkeydown = function (e) {
          if (e.which == VK.ESCAPE) {
            resetPrompt();
          } else if (e.which == VK.ENTER) {
            promptField.blur();
          }
        };
        promptField.autofocus = true;
        element.appendChild(categoryPrompt);
      }
      element.appendChild(clearfix);

      document.body.innerHTML = ''; // Clear body
      document.body.appendChild(element);

      if (position.x >= 0 && position.x < categories.length) {
        // Highlight selected Category/Link
        var selected =
          document.getElementsByClassName('category')[position.x];
        selected.className += ' active';

        if (position.y >= 0) {
          selected.getElementsByClassName('link')[position.y].className
            += ' active';
        }
      }
    }

    function save() {
      storage.set('data', toJSON());
    }

    return {
      getInstance: function () {
        if (!instance) {
          instance = init();
        }

        return instance;
      }
    }
  }) ();

  // Utility functions

  // Fill in template strings
  function compile(a, b) {
    var s = a;

    for (var p in b) {
      if (b.hasOwnProperty(p)) {
        s = s.replace('{{' + p + '}}', b[p]);
      }
    }

    return s;
  }

  // Bringin' strings to DOM life
  function magic(s) {
    var t = document.createElement('div');
    t.innerHTML = s;
    return t.firstChild;
  }

  window.onload = function () {
    StartPage.getInstance().loadSettings();
  };

}) ();

