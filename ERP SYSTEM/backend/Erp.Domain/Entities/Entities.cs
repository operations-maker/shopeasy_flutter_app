using System;
using System.Collections.Generic;

namespace Erp.Domain.Entities
{
    public class Product
    {
        public int Id { get; set; }
        public string SKU { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Type { get; set; } = "RawMaterial"; // RawMaterial, SemiFinished, FinishedGood
        public decimal UnitPrice { get; set; }
        public double StockQuantity { get; set; }
        public double ReorderLevel { get; set; }
        public string WarehouseLocation { get; set; } = string.Empty;
    }

    public class BOM
    {
        public int Id { get; set; }
        public int FinishedGoodId { get; set; }
        public Product FinishedGood { get; set; } = null!;
        public string Version { get; set; } = "1.0.0";
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public List<BOMItem> Items { get; set; } = new();
    }

    public class BOMItem
    {
        public int Id { get; set; }
        public int BOMId { get; set; }
        public int MaterialId { get; set; }
        public Product Material { get; set; } = null!;
        public double QuantityRequired { get; set; }
    }

    public class WorkOrder
    {
        public int Id { get; set; }
        public string OrderNumber { get; set; } = string.Empty;
        public int FinishedGoodId { get; set; }
        public Product FinishedGood { get; set; } = null!;
        public double TargetQuantity { get; set; }
        public double CompletedQuantity { get; set; }
        public double ScrapQuantity { get; set; }
        public string Status { get; set; } = "Pending"; // Pending, InProgress, Completed, Paused
        public DateTime ScheduledStartDate { get; set; }
        public DateTime ScheduledEndDate { get; set; }
        public int MachineAllocationId { get; set; }
        public List<ProductionLog> ProductionLogs { get; set; } = new();
    }

    public class Machine
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public string Status { get; set; } = "Idle"; // Running, Idle, Maintenance, Offline
        public double OEE { get; set; } = 85.0; // Overall Equipment Effectiveness
        public double HealthScore { get; set; } = 95.0;
        public double Temperature { get; set; }
        public double Vibration { get; set; }
    }

    public class ProductionLog
    {
        public int Id { get; set; }
        public int WorkOrderId { get; set; }
        public string LogType { get; set; } = "Output"; // Output, Scrap, Downtime
        public double Quantity { get; set; }
        public string Notes { get; set; } = string.Empty;
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }

    public class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Company { get; set; } = string.Empty;
        public string PipelineStatus { get; set; } = "Lead"; // Lead, Contacted, Opportunity, Quotation, Customer
    }

    public class Transaction
    {
        public int Id { get; set; }
        public string Code { get; set; } = string.Empty;
        public string AccountName { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public string Type { get; set; } = "Income"; // Income, Expense, Receivable, Payable
        public DateTime Date { get; set; } = DateTime.UtcNow;
        public string Description { get; set; } = string.Empty;
    }
}
