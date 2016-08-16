var AcVehicleSearch = {
  name: "ac_vehicle_search",

  initialize: function() {
    document.addEventListener('ac_vehicle_search_filter.did_change', function(e) {
      Nostalgia.updateStateFor(this.name, e.detail);
      Nostalgia.reload(this.name);
    }.bind(this));
  }
};

AcVehicleSearch.initialize();
