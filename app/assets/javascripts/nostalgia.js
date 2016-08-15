var Nostalgia = {
  LOADING_CLASS: "component-loading",

  componentsWithin: function(component) {
    return document.querySelectorAll('[data-component="' + component + '"] [data-component]');
  },

  component: function(name) {
    return document.querySelector('[data-component="' + name + '"]');
  },

  executeReplacements: function(replacements) {
    replacements.map(function(action) {
      this.component(action.replace).outerHTML = action.with_content;
    }.bind(this));
  },

  asQueryParams: function(keyValueObject) {
    var key;
    var queryParams = [];
    for(key in keyValueObject) {
      queryParams.push(key + "=" + keyValueObject[key]);
    }
    return queryParams.join("&");
  },

  loadInReplacementsFrom: function(url) {
    var request = new XMLHttpRequest();
    request.onload = function (e) {
      this.executeReplacements(e.target.response.replacements);
      this.didLoad(e.target.response.component);
    }.bind(this);
    request.open('GET', url, true);
    request.responseType='json';
    request.send();
  },

  didLoad: function(name) {
    this.markAsLoaded(this.component(name));
    var index;
    var childComponents = this.componentsWithin(name);
    for (index = 0; index < childComponents.length; ++index) {
      this.markAsLoaded(childComponents[index]);
    }
  },

  willLoad: function(name) {
    this.markAsLoading(this.component(name));
    var index;
    var childComponents = this.componentsWithin(name);
    for (index = 0; index < childComponents.length; ++index) {
      this.markAsLoading(childComponents[index]);
    }
  },

  markAsLoading: function(node) {
    node.classList.add(this.LOADING_CLASS);
  },

  markAsLoaded: function(node) {
    node.classList.remove(this.LOADING_CLASS);
  },

  reload: function(component) {
    this.willLoad(component);
    var url = "/api/components/" + component + "?" + this.asQueryParams(this.stateFor(component));
    this.loadInReplacementsFrom(url);
  },

  stateFor: function(name) {
    return this.component(name).dataset;
  },

  updateStateFor: function(name, newState) {
    return this.component(name).setAttribute("data-" + newState.key, newState.value);
  }
};
