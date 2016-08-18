console.log('LED controller started');


// get commands and draw buttons

const vm = new Vue({
  el: 'body',
  data: {
    currentDevice: {
      host: '192.168.178.69'
    },
    files: [],
    currentFile: {
      path: null,
      content: null
    }
  },
  methods: {
    getFiles: function() {
      xhr({
        method: 'POST',
        url: 'http://' + vm.currentDevice.host + '/cmd/get-files.lua'
      }, function() {
        vm.files = this.responseText.split('\n').filter(line=>!!line && line.length);
      });
    },
    loadFile: function (file, evt) {
      evt.preventDefault();

      xhr({
        method: 'GET',
        url: 'http://' + vm.currentDevice.host + '/' + file
      }, function() {
        vm.currentFile.path = file;
        vm.currentFile.content = this.responseText;
      });
    },
    deleteFile: function(file) {
      xhr({
        method: 'DElETE',
        url: 'http://' + vm.currentDevice.host + '/' + file
      }, function() {
        vm.files.$remove(file);
      });
    },
    saveFile: function() {
      xhr({
        method: 'PUT',
        url: 'http://' + vm.currentDevice.host + '/' + vm.currentFile.path,
        body: vm.currentFile.content
      }, function () {
        console.log('saved')
      });
    }
  }
});


function xhr(opts, handler) {
  var url = opts.url;
  var method = opts.method;
  var body = opts.body;

  var oReq = new XMLHttpRequest();
  oReq.addEventListener("load", handler);
  oReq.open(method, url);
  oReq.setRequestHeader('Content-Type', 'text/plain');
  oReq.send(body);
}

vm.getFiles();
