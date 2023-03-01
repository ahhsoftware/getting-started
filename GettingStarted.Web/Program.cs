using System.Diagnostics.Metrics;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

string connection = builder.Configuration["ConnectionString"];
builder.Services.AddSingleton<GettingStarted.DataServices.Good.Service>((o) =>
{
    return new GettingStarted.DataServices.Good.Service(connection);
});
//builder.Services.AddSingleton<GettingStarted.DataServices.Better.Service>((o) =>
//{
//    return new GettingStarted.DataServices.Better.Service(connection);
//});
builder.Services.AddSingleton<GettingStarted.DataServices.Best.Service>((o) =>
{
    return new GettingStarted.DataServices.Best.Service(connection);
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
