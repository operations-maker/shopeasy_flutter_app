using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Erp.Infrastructure.Persistence;
using Erp.Domain.Entities;
using System;
using System.Linq;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure SQLite DbContext
builder.Services.AddDbContext<ErpDbContext>(options =>
    options.UseSqlite("Data Source=erp.db"));

// Enable CORS for development
builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy", policy =>
    {
        policy.AllowAnyHeader()
              .AllowAnyMethod()
              .AllowAnyOrigin();
    });
});

var app = builder.Build();

// Seed Database
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ErpDbContext>();
    db.Database.EnsureCreated();

    if (!db.Products.Any())
    {
        // Add Products
        var p1 = new Product { SKU = "RM-STEEL-001", Name = "High-Grade Steel Sheet", Description = "Raw structural steel sheets", Type = "RawMaterial", UnitPrice = 12.50m, StockQuantity = 1200, ReorderLevel = 500, WarehouseLocation = "Warehouse A" };
        var p2 = new Product { SKU = "RM-CHIP-005", Name = "Microprocessor Unit X1", Description = "Control unit chips", Type = "RawMaterial", UnitPrice = 45.00m, StockQuantity = 350, ReorderLevel = 100, WarehouseLocation = "Warehouse B" };
        var p3 = new Product { SKU = "FG-MOTOR-100", Name = "Smart Brushless Motor V2", Description = "Finished smart motor assembly", Type = "FinishedGood", UnitPrice = 250.00m, StockQuantity = 45, ReorderLevel = 10, WarehouseLocation = "Warehouse A" };
        
        db.Products.AddRange(p1, p2, p3);
        db.SaveChanges();

        // Add BOM
        var bom = new BOM { FinishedGoodId = p3.Id, Version = "2.1.0", IsActive = true };
        db.BOMs.Add(bom);
        db.SaveChanges();

        db.BOMItems.AddRange(
            new BOMItem { BOMId = bom.Id, MaterialId = p1.Id, QuantityRequired = 2.5 },
            new BOMItem { BOMId = bom.Id, MaterialId = p2.Id, QuantityRequired = 1 }
        );
        db.SaveChanges();

        // Add Machines
        db.Machines.AddRange(
            new Machine { Code = "MC-CNC-01", Name = "CNC Milling Machine 5-Axis", Status = "Running", OEE = 89.4, HealthScore = 97.2, Temperature = 68.5, Vibration = 0.04 },
            new Machine { Code = "MC-ASM-02", Name = "Robotic Assembly Arm Alpha", Status = "Idle", OEE = 78.1, HealthScore = 91.0, Temperature = 55.2, Vibration = 0.01 },
            new Machine { Code = "MC-LSR-03", Name = "High-Precision Laser Cutter", Status = "Running", OEE = 84.5, HealthScore = 88.5, Temperature = 74.1, Vibration = 0.09 }
        );
        db.SaveChanges();

        // Add Work Orders
        db.WorkOrders.Add(new WorkOrder
        {
            OrderNumber = "WO-2026-001",
            FinishedGoodId = p3.Id,
            TargetQuantity = 100,
            CompletedQuantity = 35,
            ScrapQuantity = 2,
            Status = "InProgress",
            ScheduledStartDate = DateTime.UtcNow,
            ScheduledEndDate = DateTime.UtcNow.AddDays(3)
        });
        db.SaveChanges();

        // Add Customers (CRM)
        db.Customers.AddRange(
            new Customer { Name = "John Smith", Email = "jsmith@aerotech.com", Phone = "+1-555-0199", Company = "AeroTech Solutions", PipelineStatus = "Opportunity" },
            new Customer { Name = "Sarah Jenkins", Email = "sjenkins@nextgen-mfg.com", Phone = "+1-555-0182", Company = "NextGen Manufacturing", PipelineStatus = "Quotation" }
        );
        db.SaveChanges();

        // Add Transactions (Finance)
        db.Transactions.AddRange(
            new Transaction { Code = "TR-90021", AccountName = "Sales Revenue", Amount = 12450.00m, Type = "Income", Description = "Motor Batch #82 dispatch" },
            new Transaction { Code = "TR-90022", AccountName = "Steel Supplier Inc", Amount = -4500.00m, Type = "Expense", Description = "Bulk steel raw materials purchase" },
            new Transaction { Code = "TR-90023", AccountName = "Electricity Utility", Amount = -1890.00m, Type = "Expense", Description = "Shop floor power bill" }
        );
        db.SaveChanges();
    }
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("CorsPolicy");
app.UseAuthorization();
app.MapControllers();

app.Run();
