using Microsoft.JSInterop;

namespace GettingStarted.Blazor.Services
{
    public class JsService
    {
        private readonly IJSRuntime javascript;

        public JsService(IJSRuntime javascript)
        {
            this.javascript = javascript;
        }

        public async Task<bool> Confirm(string message)
        {
            return await javascript.InvokeAsync<bool>("confirm", message);
        }

        public async Task Alert(string message)
        {
            await javascript.InvokeVoidAsync("alert", message);
        }
    }
}
