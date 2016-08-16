var Nostalgia = {
  LOADING_CLASS: "component-loading",

  init: function() {
    var index;
    var components = this.getAllComponents();
    for (index = 0; index < components.length; ++index) {
      if(this.noReloadDependencies(components[index])) { continue; }

      var controlsInComponent = components[index].querySelectorAll("select");
      
      var controlIndex;
      for (controlIndex = 0; controlIndex < controlsInComponent.length; ++controlIndex) {
        controlsInComponent[controlIndex].setAttribute('onchange', "Nostalgia.reloadDependentComponents(this)");
      }
    }
  },

  reloadDependentComponents: function(control) {
    this.triggerSelectChanged(control);
  },

  triggerSelectChanged: function(select) {
    var componentChanged = this.parentComponent(select);
    this.updateStateFor(componentChanged, { key: select.name, value: select.value });
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

  getAllComponents: function() {
    return document.querySelectorAll('[data-component]');
  },

  getChildComponents: function(component) {
    return document.querySelectorAll('[data-component="' + component.dataset.component + '"] [data-component]');
  },

  getComponent: function(name) {
    return document.querySelector('[data-component="' + name + '"]');
  },

  executeReplacements: function(replacements) {
    replacements.map(function(action) {
      this.getComponent(action.replace).outerHTML = action.with_content;
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
      this.markComponentAsLoaded(this.getComponent(e.target.response.component));
      this.init();
    }.bind(this);
    request.open('GET', url, true);
    request.responseType='json';
    request.send();
  },

  markComponentAsLoaded: function(component) {
    this.markNodeAsLoaded(component);

    var index;
    var childComponents = this.getChildComponents(component);
    for (index = 0; index < childComponents.length; ++index) {
      this.markNodeAsLoaded(childComponents[index]);
    }
  },

  markComponentAsLoading: function(component) {
    this.markNodeAsLoading(component);

    var index;
    var childComponents = this.getChildComponents(component);
    for (index = 0; index < childComponents.length; ++index) {
      this.markNodeAsLoading(childComponents[index]);
    }

    this.markDependentComponentsAsLoading(component);
  },

  markDependentComponentsAsLoading: function(component) {
    if(!this.shouldReloadOthers(component)) { return; }

    var index;
    var dependentComponentNames = JSON.parse(component.dataset.onchangeReload);
    for (index = 0; index < dependentComponentNames.length; ++index) {
      if (dependentComponentNames[index] !== component.dataset.component) {
        this.markComponentAsLoading(this.getComponent(dependentComponentNames[index]));
      }
    }
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
