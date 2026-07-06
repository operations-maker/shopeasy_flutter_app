using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Erp.Infrastructure.Persistence;
using Erp.Domain.Entities;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

namespace Erp.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductionController : ControllerBase
    {
        private readonly ErpDbContext _context;
        public ProductionController(ErpDbContext context) => _context = context;

        [HttpGet("machines")]
        public async Task<ActionResult<IEnumerable<Machine>>> GetMachines()
        {
            return await _context.Machines.ToListAsync();
        }

        [HttpGet("workorders")]
        public async Task<ActionResult<IEnumerable<WorkOrder>>> GetWorkOrders()
        {
            return await _context.WorkOrders.Include(w => w.FinishedGood).ToListAsync();
        }

        [HttpGet("boms")]
        public async Task<ActionResult<IEnumerable<BOM>>> GetBOMs()
        {
            return await _context.BOMs
                .Include(b => b.FinishedGood)
                .Include(b => b.Items)
                .ThenInclude(bi => bi.Material)
                .ToListAsync();
        }
    }

    [ApiController]
    [Route("api/[controller]")]
    public class InventoryController : ControllerBase
    {
        private readonly ErpDbContext _context;
        public InventoryController(ErpDbContext context) => _context = context;

        [HttpGet("products")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            return await _context.Products.ToListAsync();
        }

        [HttpPost("adjust")]
        public async Task<IActionResult> AdjustStock([FromBody] StockAdjustmentDto dto)
        {
            var product = await _context.Products.FindAsync(dto.ProductId);
            if (product == null) return NotFound();

            product.StockQuantity += dto.AdjustmentAmount;
            await _context.SaveChangesAsync();
            return Ok(product);
        }
    }

    public class StockAdjustmentDto
    {
        public int ProductId { get; set; }
        public double AdjustmentAmount { get; set; }
    }

    [ApiController]
    [Route("api/[controller]")]
    public class CRMController : ControllerBase
    {
        private readonly ErpDbContext _context;
        public CRMController(ErpDbContext context) => _context = context;

        [HttpGet("customers")]
        public async Task<ActionResult<IEnumerable<Customer>>> GetCustomers()
        {
            return await _context.Customers.ToListAsync();
        }
    }

    [ApiController]
    [Route("api/[controller]")]
    public class FinanceController : ControllerBase
    {
        private readonly ErpDbContext _context;
        public FinanceController(ErpDbContext context) => _context = context;

        [HttpGet("transactions")]
        public async Task<ActionResult<IEnumerable<Transaction>>> GetTransactions()
        {
            return await _context.Transactions.ToListAsync();
        }
    }
}
