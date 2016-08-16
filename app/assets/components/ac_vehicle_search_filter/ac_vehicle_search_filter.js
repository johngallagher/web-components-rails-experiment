var AcVehicleSearchFilter = {
  didChange: function(element) {
    var event = new CustomEvent('ac_vehicle_search_filter.did_change', { detail: { key: element.name, value: element.value }});
    document.dispatchEvent(event);
  }
};
