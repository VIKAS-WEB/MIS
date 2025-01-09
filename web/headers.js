// Add CORS headers to all outgoing requests
window.addEventListener('load', function() {
    var originalXHR = window.XMLHttpRequest;
    window.XMLHttpRequest = function() {
        var xhr = new originalXHR();
        var originalOpen = xhr.open;
        xhr.open = function() {
            var result = originalOpen.apply(this, arguments);
            this.setRequestHeader('Accept', '*/*');
            this.setRequestHeader('Origin', window.location.origin);
            return result;
        };
        return xhr;
    };
});