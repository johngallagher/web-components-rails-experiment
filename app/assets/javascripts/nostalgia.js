var Nostalgia = {
  LOADING_CLASS: "component-loading",

  init: function() {
    this.getComponentsWithReloadDependencies().forEach(function(component) {
      this.controlsWithin(component).forEach(function(control) {
        this.onChangeCallNostalgia(control);
      }, this);
    }, this);
  },

  controlsWithin: function(component) {
    return component.querySelectorAll("select, input");
  },

  onChangeCallNostalgia: function(control) {
    control.setAttribute('onchange', "Nostalgia.reloadDependentComponents(this)");
  },

  reloadDependentComponents: function(control) {
    var componentChanged = this.parentComponent(control);
    this.updateStateFor(componentChanged, { key: control.name, value: control.value });
    this.reload(componentChanged);
  },

  reload: function(componentChanged) {
    this.markComponentAsLoading(componentChanged);

    if(this.shouldReloadOthers(componentChanged)) {
      var componentUpdateUrl = "component_updates?" + this.asQueryParams(this.stateFor(componentChanged));
      this.loadInReplacementsFrom(componentUpdateUrl);
    }
  },

  noReloadDependencies: function(component) {
    return !this.shouldReloadOthers(component);
  },

  shouldReloadOthers: function(component) {
    return component.dataset.onchangeReload !== undefined;
  },

  getComponentsWithReloadDependencies: function() {
    return document.querySelectorAll('[data-component] [data-onchange-reload]');
  },

  getChildComponents: function(component) {
    return document.querySelectorAll('[data-component="' + component.dataset.component + '"] [data-component]');
  },

  getComponent: function(name) {
    return document.querySelector('[data-component="' + name + '"]');
  },

  toSnakeCase: function(string) {
    return string.replace(/([A-Z])/g, function(match) { return "_" + match.toLowerCase(); });
  },

  asQueryParams: function(keyValueObject) {
    var key;
    var queryParams = [];
    for(key in keyValueObject) {
      queryParams.push(this.toSnakeCase(key) + "=" + keyValueObject[key]);
    }
    return queryParams.join("&");
  },

  loadInReplacementsFrom: function(url) {
    var request = new XMLHttpRequest();
    request.onload = function (e) {
      this.executeReplacements(e.target.response.replacements);
      this.markPageAsLoaded();
      this.init();
    }.bind(this);
    request.open('GET', url, true);
    request.responseType='json';
    request.send();
  },

  markPageAsLoaded: function() {
    this.componentsLoading().forEach(function(component) {
      this.markNodeAsLoaded(component);
    }, this);
  },

  componentsLoading: function() {
    return document.querySelectorAll("." + this.LOADING_CLASS);
  },

  executeReplacements: function(replacements) {
    replacements.forEach(function(action) {
      var elementsToReload = document.querySelectorAll(action.replace);
      var newContents = action.with_elements;
      this.replaceElementsWithContent(elementsToReload, newContents);
    }, this);
  },

  replaceElementsWithContent: function(elements, contents) {
    elements.forEach(function(element, index) {
      element.outerHTML = contents[index];
    }, this);
  },

  markComponentAsLoading: function(component) {
    this.markNodeAsLoading(component);
    this.markChildComponentsAsLoading(component);
    this.markDependentComponentsAsLoading(component);
  },

  markChildComponentsAsLoading: function(component) {
    this.getChildComponents(component).forEach(function(childComponent) {
      this.markNodeAsLoading(childComponent);
    }, this);
  },

  markDependentComponentsAsLoading: function(component) {
    if(this.noReloadDependencies(component)) { return; }

    var ourComponentName = component.dataset.component;

    this.dependentComponentNames(component).forEach(function(name) {
      if (name !== ourComponentName) {
        this.markComponentAsLoading(this.getComponent(name));
      }
    }, this);
  },

  dependentComponentNames: function(component) {
    return JSON.parse(component.dataset.onchangeReload);
  },

  markNodeAsLoading: function(node) {
    node.classList.add(this.LOADING_CLASS);
  },

  markNodeAsLoaded: function(node) {
    node.classList.remove(this.LOADING_CLASS);
  },

  stateFor: function(component) {
    return component.dataset;
  },

  updateStateFor: function(component, newState) {
    return component.setAttribute("data-" + newState.key, newState.value);
  },

  parentComponent: function(node) {
    return this.getComponent(this.getParentComponentName(node));
  },

  getParentComponentName: function(node) {
    var currentNode = node;
    var foundComponent = false;
    var atRootNode = false;
    do {
       currentNode = currentNode.parentNode;
       foundComponent = currentNode.hasAttribute("data-component");
       atRootNode = currentNode === undefined;
    } while(!foundComponent && !atRootNode);

    return currentNode.getAttribute("data-component");
  }
};

document.addEventListener("DOMContentLoaded", function() { 
  Nostalgia.init();
});
