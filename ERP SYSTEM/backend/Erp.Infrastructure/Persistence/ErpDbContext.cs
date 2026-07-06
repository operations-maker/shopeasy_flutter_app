using Microsoft.EntityFrameworkCore;
using Erp.Domain.Entities;

namespace Erp.Infrastructure.Persistence
{
    public class ErpDbContext : DbContext
    {
        public ErpDbContext(DbContextOptions<ErpDbContext> options) : base(options)
        {
        }

        public DbSet<Product> Products => Set<Product>();
        public DbSet<BOM> BOMs => Set<BOM>();
        public DbSet<BOMItem> BOMItems => Set<BOMItem>();
        public DbSet<WorkOrder> WorkOrders => Set<WorkOrder>();
        public DbSet<Machine> Machines => Set<Machine>();
        public DbSet<ProductionLog> ProductionLogs => Set<ProductionLog>();
        public DbSet<Customer> Customers => Set<Customer>();
        public DbSet<Transaction> Transactions => Set<Transaction>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<BOM>()
                .HasOne(b => b.FinishedGood)
                .WithMany()
                .HasForeignKey(b => b.FinishedGoodId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<BOMItem>()
                .HasOne(bi => bi.Material)
                .WithMany()
                .HasForeignKey(bi => bi.MaterialId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<WorkOrder>()
                .HasOne(w => w.FinishedGood)
                .WithMany()
                .HasForeignKey(w => w.FinishedGoodId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
