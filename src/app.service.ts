import { Injectable } from '@nestjs/common';
import { PrismaService } from 'nestjs-prisma';

@Injectable()
export class AppService {
  constructor(private readonly prismaService: PrismaService) {}

  async getShipments(
    companyId: number,
    sort: string,
    direction: string,
    internationalTransportationMode: string,
    page: number,
    per: number,
  ) {
    page = page || 1;
    per = per || 4;

    const shipments: any = await this.prismaService.shipments.findMany({
      where: {
        company_id: companyId,
        ...{
          international_transportation_mode: internationalTransportationMode,
        },
      },
      orderBy: sort && direction ? { [sort]: direction } : { id: 'asc' },
      skip: (page - 1) * per,
      take: per,
    });

    const shipment_products =
      await this.prismaService.shipment_products.findMany({
        where: { id: { in: shipments.map((s) => s.id) } },
      });

    const products = await this.prismaService.products.findMany({
      where: { id: { in: shipment_products.map((sp) => sp.product_id) } },
    });

    shipments.map((s) => {
      s.products = shipment_products
        .filter((sp) => sp.shipment_id == s.id)
        .map((sp) => {
          const product = products.find((p) => p.id == sp.product_id);
          return {
            id: product.id,
            sku: product.sku,
            description: product.description,
            quantity: sp.quantity,

            // TODO: This could better move to an API service
            active_shipment_count: shipment_products.filter(
              (sp) => sp.product_id == product.id,
            ),
          };
        });
    });

    return shipments.map((s) => {
      return { id: s.id, name: s.name, products: s.products };
    });
  }
}
