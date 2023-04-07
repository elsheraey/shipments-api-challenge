import {
  Controller,
  Get,
  Query,
  UnprocessableEntityException,
} from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/api/v1/shipments')
  async getShipments(
    @Query('company_id') companyId: string,
    @Query('sort') sort: string,
    @Query('direction') direction: string,
    @Query('international_transportation_mode')
    internationalTransportationMode: string,
    @Query('page') page: string,
    @Query('per') per,
  ) {
    if (!companyId)
      throw new UnprocessableEntityException({
        errors: ['company_id is required'],
      });

    const shipments = await this.appService.getShipments(
      +companyId,
      sort,
      direction,
      internationalTransportationMode,
      +page,
      +per,
    );
    return { shipments: shipments };
  }
}
